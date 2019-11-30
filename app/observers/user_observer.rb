class UserObserver < Mongoid::Observer
  include ApplicationHelper

  def before_save user
    user.generate_referral_code
    if user.phone.present?
      user.phone = Phonelib.parse(user.phone).to_s
    end
  end
end
