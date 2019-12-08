require 'autoinc'
class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc
  include ArrayBlankRejectable
  extend FilterByCriteria
  
  field :name, type: String
  field :industry, type: String
  field :description, type: String
  field :company_id, type: Integer
  field :company_code, type: String
  field :status, type: String
  field :preferred_login, type: String, default: "phone"
  field :enable_communication, type: Hash, default: {"email": true, "sms": true}

  has_many :users
  has_many :restaurants
  has_one :logo, class_name: 'Asset', as: :assetable
  
  validates :name, :status, presence: true
  validates :name, length: {minimum: 4}
  validates :status, inclusion: {in: Proc.new{ Company.available_statuses.collect{|x| x[:id]} } }, allow_blank: true
  validates :preferred_login, inclusion: {in: Proc.new{ Company.available_preferred_logins.collect{|x| x[:id]} } }

  increments :company_id

  def self.available_statuses
    [
      {id: "active", text: "Active", default: true},
      {id: "inactive", text: "Inactive"}
    ]
  end

  def self.available_preferred_logins
    [
      {id: 'phone', text: 'Phone Based'},
      {id: 'email', text: 'Email Based'}
    ]
  end

  def sms_enabled?
    self.enable_communication["sms"]
  end

  def email_enabled?
    self.enable_communication["email"]
  end

  def self.user_based_scope(user, _params = {})
    custom_scope = {}
    if user.role?('admin')
      custom_scope = {}
    elsif user.role?('crm') || user.role?('pos')
      custom_scope = { id: {'$in': current_user.manage_company_ids } }
    else
      custom_scope = { id: current_user.company_id }
    end
    custom_scope
  end

  def self.build_criteria(params = {})
    criteria = super(params)
    criteria
  end
end