module DatabaseSeeds
  module SmsTemplate
    def self.seed
      Template::SmsTemplate.create(subject_class: "User", name: "user_registered", content: "Dear <%= name %>, thank you for registering at <%= app_configuration.name %>. To confirm your account, please click <%= confirmation_url %>. You can also confirm your account using your phone & <%= I18n.t('global.otp') %>.") if Template::SmsTemplate.where(name: "user_registered").blank?

      Template::SmsTemplate.create({subject_class: "User", name: "otp", content: "Your <%= I18n.t('global.otp') %> for logging into <%= booking_portal_client.name %> is <%= otp_code %>."})  if Template::SmsTemplate.where(name: "otp").blank?

      
      return Template::SmsTemplate.count
    end
  end
end
