class EmailObserver < Mongoid::Observer
  include ApplicationHelper
  def before_create email
    email.to ||= []
    email.cc ||= []
    email.to = email.recipients.distinct(:email).compact.reject{|x| x.blank?} if email.to.blank?
    email.cc = email.cc_recipients.distinct(:email).compact.reject{|x| x.blank?} if email.cc.blank?
  end

  def before_save email
    triggered_by = email.triggered_by
    if email.email_template_id.present?
      email_template = Template::EmailTemplate.find email.email_template_id
      begin
        email.body = ERB.new(app_configuration.email_header).result( binding ) + email_template.parsed_content(triggered_by) + ERB.new(app_configuration.email_footer).result( binding )
      rescue => e
        email.body = ""
      end
      email.text_only_body = TemplateParser.parse(email_template.text_only_body, triggered_by)
      email.subject = email_template.parsed_subject(triggered_by)
    else
      email.body = TemplateParser.parse(email.body, triggered_by)
      email.text_only_body = TemplateParser.parse(email.text_only_body, triggered_by)
      email.subject = TemplateParser.parse(email.subject, triggered_by)
    end
  end

  def after_create email
    # Email sent when
    # Template Present  |   Templat Is Active  |   ENV in list  |   SMS sent or not
    #      T            |          T           |       T        |        yes
    #      T            |          T           |       F        |         no
    #      T            |          F           |       T        |         no
    #      T            |          F           |       F        |         no
    #      F            |          -           |       T        |        yes
    #      F            |          -           |       F        |         no
    #      F            |          -           |       T        |        yes
    #      F            |          -           |       F        |         no
    if email.to.present?
      if ( !email.email_template || email.email_template.try(:is_active?) ) && (Rails.env.production? || Rails.env.staging?)
        if email.attachments.present?
          Communication::Email::MailgunWorker.perform_in(2.minutes, email.id.to_s)
        else
          Communication::Email::MailgunWorker.perform_async(email.id.to_s)
        end
      else
        attachment_urls = {}
        email.attachments.collect do |doc|
          attachment_urls[doc.file_name] = doc.file.url
        end
        ApplicationMailer.test({
          to: email.recipients.distinct(:email),
          cc: email.cc,
          body: email.body,
          subject: email.subject,
          attachment_urls: attachment_urls
        }).deliver
      end
    end
  end
end
