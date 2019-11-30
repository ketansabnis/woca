module DatabaseSeeds
  module SmsTemplate
    def self.seed
      Template::SmsTemplate.create(subject_class: "User", name: "user_registered", content: "Dear <%= name %>, thank you for registering at <%= app_configuration.name %>. To confirm your account, please click <%= confirmation_url %>. You can also confirm your account using your phone & <%= I18n.t('global.otp') %>.") if Template::SmsTemplate.where(name: "user_registered").blank?
      
      return Template::SmsTemplate.count
    end
  end
end
