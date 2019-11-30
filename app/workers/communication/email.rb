module Communication
  module Email
    class MailgunWorker
      include Sidekiq::Worker
      include ApplicationHelper
      # finds the email object, and email_settings from agency, finds the correct provider and sends the email's json to provider_object for sending the email
      def perform email_id
        email = ::Email.find email_id
        email_json = email.as_json.with_indifferent_access
        if email.attachments.present?
          email_json[:attachments] = email.attachments.collect do |doc|
            if Rails.env.production? || Rails.env.staging?
              CarrierWave::Uploader::Download::RemoteFile.new(doc.file.url)
            else
              File.open("#{Rails.root}/public" + doc.file.url,'r')
            end
          end
        end

        # unless setting[:provider]
        #   fail "An Email Setting json must contain 'provider' key"
        # end
        # setting[:domain] = ::Email.default_email_domain

        begin
          message = get_message_object(email_json, app_configuration.sender_email)
          mailgun = ::Mailgun::Client.new app_configuration.mailgun_private_api_key
          mailgun.send_message(app_configuration.mailgun_email_domain, message)
          email.set({sent_on: Time.now})
        rescue StandardError => e
          if Rails.env.production? || Rails.env.staging?
            Honeybadger.notify(e, context: email.as_json)
          else
            puts "==============================="
            puts "Error sending email:#{e.class} : #{e.message}"
            puts e.backtrace
            puts "==============================="
          end
        end
      end

      def get_message_object email_json, sender_email
        email_json = email_json.with_indifferent_access
        message = ::Mailgun::MessageBuilder.new
        email_json[:to].each{|to| message.add_recipient(:to, to)}
        email_json[:cc].each{|cc| message.add_recipient(:cc, cc)}

        action_mailer_email = ApplicationMailer.test(to: email_json[:to],cc: email_json[:cc], subject: email_json[:subject], body: email_json[:body])

        message.from(sender_email)
        message.subject(email_json[:subject])
        message.body_text(email_json[:text_only_body])
        message.body_html(action_mailer_email.html_part.body.to_s)

        if(email_json[:tracking].present?)
          message.add_campaign_id(email_json[:tracking][:campaign_id]) if(email_json[:tracking][:campaign_id])
          message.track_clicks(true)
          message.track_opens(true)
        end

        if(email_json[:attachments].present?)
          email_json[:attachments].each do |attachment|
            message.add_attachment(attachment)
          end if email_json[:attachments].is_a?(Array)
          message.add_attachment(email_json[:attachments]) if email_json[:attachments].is_a?(File) || email_json[:attachments].is_a?(String)
        end
        message.message["h:Reply-To"] = email_json[:in_reply_to]
        message.message["v:email_id"] = email_json[:_id].to_s
        message
      end
    end
  end
end
