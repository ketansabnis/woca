class Referral
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String, default: ""
  field :phone, type: String, default: ""
  field :referral_code, type: String

  belongs_to :referred_by, class_name: 'User'
  belongs_to :referred_user, class_name: 'User', optional: true

  def name
    "#{first_name} #{last_name}"
  end
end