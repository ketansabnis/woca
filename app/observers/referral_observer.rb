class ReferralObserver < Mongoid::Observer

  def after_create(referral)
    Email.create!({
      email_template_id: Template::EmailTemplate.find_by(name: "referral_invitation").id,
      to: [referral.email],
      cc: [referral.referred_by.email],
      recipients: [referral.referred_by],
      triggered_by_id: referral.id,
      triggered_by_type: referral.class.to_s
    }) if !referral.email.blank?

    Sms.create!({
      recipient: referral.referred_by,
      to: [referral.phone],
      sms_template_id: Template::SmsTemplate.find_by(name: "referral_invitation").id,
      triggered_by_id: referral.id,
      triggered_by_type: referral.class.to_s
    }) if !referral.phone.blank?
  end
end
