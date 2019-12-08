require "active_model_otp"
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ArrayBlankRejectable
  include ActiveModel::OneTimePassword
  include ApplicationHelper
  include OtpLoginHelperMethods
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, authentication_keys: [:login]
  
  # common details
  field :first_name, type: String, default: ""
  field :last_name, type: String, default: ""
  field :display_name, type: String, default: ""
  field :married, type: Boolean, default: false
  field :gender, type: String
  field :dob, type: Date
  
  field :role, type: String, default: "user"
  field :deparment, type: String
  field :job_title, type: String
  field :manager_name, type: String
  field :manager_email, type: String, default: ""
  field :manager_phone, type: String, default: ""
  field :status, type: String, default: 'active'
  
  field :employee_id, type: String
  field :time_zone, type: String, default: "Mumbai"
  field :otp_secret_key, type: String
  field :referral_code, type: String
  
  ## Database authenticatable
  field :email, type: String, default: ""
  field :phone, type: String, default: ""
  field :encrypted_password, type: String, default: ""
  
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  
  ## Rememberable
  field :remember_created_at, type: Time
  
  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  
  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable
  
  ## Lockable
  field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  field :locked_at,       type: Time
  
  ## Password expirable
  field :password_changed_at, type: DateTime
  
  ## Password archivable
  field :password_archivable_type, type: String
  field :password_archivable_id, type: String
  field :password_salt, type: String # Optional. bcrypt stores the salt in the encrypted password field so this column may not be necessary.
  
  ## Session limitable
  field :unique_session_id, type: String
  field :uniq_user_agent, type: String
  
  ## Expirable
  field :last_activity_at, type: DateTime
  field :expired_at, type: DateTime
  field :manage_company_ids, type: Array, default: []
  
  ## Paranoid verifiable
  field :paranoid_verification_code, type: String
  field :paranoid_verification_attempt, type: Integer, default: 0
  field :paranoid_verified_at, type: DateTime
  
  ## Security questionable
  
  delegate :name, :role, :role?, :email, to: :manager, prefix: true, allow_nil: true
  delegate :name, :role, :email, to: :confirmed_by, prefix: true, allow_nil: true  
  
  # OTP Related
  def self.otp_length
    6
  end
  has_one_time_password length: User.otp_length
  default_scope -> {desc(:created_at)}
  attr_accessor :login, :login_otp
  
  # Relations
  belongs_to :company, optional: true
  belongs_to :referred_by, class_name: 'User', optional: true
  has_many :addresses, as: :addressable, class_name: "Address"
  has_many :smses, as: :triggered_by, class_name: "Sms"
  has_many :emails, as: :triggered_by, class_name: "Email"
  has_many :referrals, class_name: 'User', foreign_key: :referred_by_id
  
  validates :first_name, :role, presence: true
  validates :phone, uniqueness: true, phone: { possible: true, types: [:voip, :personal_number, :fixed_or_mobile]}, if: Proc.new{|user| user.email.blank? }
  validates :email, uniqueness: true, if: Proc.new{|user| user.phone.blank? }
  validates :role, inclusion: {in: Proc.new{ |user| User.available_roles.collect{|x| x[:id]} } }
  validates :status, inclusion: {in: Proc.new{ |user| User.available_statuses.collect{|x| x[:id]} } }
  validates :gender, inclusion: {in: Proc.new{ |user| User.available_genders.collect{|x| x[:id]} } }
  validate :valid_manage_company_ids
  
  def self.available_roles
    roles = [
      {id: 'admin', text: 'Administrator'},
      {id: 'crm', text: 'CRM'},
      {id: 'pos', text: 'POS'},
      {id: 'pos_manager', text: 'POS Manager'},
      {id: 'company_admin', text: 'Company Administrator'},
      {id: 'user', text: 'Customer', default: true}
    ]
    roles
  end
  
  def self.available_genders
    roles = [
      {id: 'm', text: 'Male', default: true},
      {id: 'f', text: 'Female'},
      {id: 'n', text: 'Other'}
    ]
    roles
  end
  
  def self.available_statuses
    [
      {id: "active", text: "Active", default: true},
      {id: "inactive", text: "Inactive"}
    ]
  end
  
  def role?(role)
    return (self.role.to_s == role.to_s)
  end
  
  def self.build_criteria params={}
    selector = {}
    if params[:filters].present?
      if params[:filters][:role].present?
        if params[:filters][:role].is_a?(Array)
          selector = {role: {"$in": params[:filters][:role] }}
        elsif params[:filters][:role].is_a?(ActionController::Parameters)
          selector = {role: params[:filters][:role].to_unsafe_h }
        else
          selector = {role: params[:filters][:role] }
        end
      end
      if params[:filters][:confirmation].present?
        if params[:filters][:confirmation].eql?("not_confirmed")
          selector[:confirmed_at] = nil
        else
          selector[:confirmed_at] = {"$ne": nil}
        end
      end
    end
    selector[:role] = {"$ne": "admin"} if selector[:role].blank?
    or_selector = {}
    if params[:search].present?
      regex = ::Regexp.new(::Regexp.escape(params[:search]), 'i')
      or_selector = {"$or": [{first_name: regex}, {last_name: regex}, {email: regex}, {phone: regex}] }
    end
    self.and([selector, or_selector])
  end
  
  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
  
  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end
  
  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
  
  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end
  
  def password_required?
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end
  
  def ds_name
    "#{name} - #{email} - #{phone}"
  end
  
  def generate_referral_code
    if self.customer? && self.referral_code.blank?
      self.referral_code = "#{app_configuration.short_name}-#{SecureRandom.hex(4)}"
    else
      self.referral_code
    end
  end
  
  def customer?
    self.role == "user"
  end
  
  def dashboard_url
    url = Rails.application.routes.url_helpers
    host = Rails.application.config.action_mailer.default_url_options[:host]
    port = Rails.application.config.action_mailer.default_url_options[:port].to_i
    host = (port == 443 ? "https://" : "http://") + host
    host = host + ((port == 443 || port == 80 || port == 0) ? "" : ":#{port}")
    url.dashboard_url(host: host)
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def login
    @login || self.phone || self.email
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    login = conditions.delete(:email) if login.blank? && conditions.keys.include?(:email)
    login = conditions.delete(:phone) if login.blank? && conditions.keys.include?(:phone)
    if login.blank? && warden_conditions[:confirmation_token].present?
      confirmation_token = warden_conditions.delete(:confirmation_token)
      where(confirmation_token: confirmation_token).first
    elsif login.blank? && warden_conditions[:reset_password_token].present?
      reset_password_token = warden_conditions.delete(:reset_password_token)
      where(reset_password_token: reset_password_token).first
    elsif login.present?
      any_of({phone: login}, email: login).first
    end
  end
  
  def is_active?
    self.status == 'active'
  end
  
  def active_for_authentication?
    super && is_active?
  end
  
  def inactive_message
    is_active? ? super : :is_active
  end
  
  def self.find_record login
    where("function() {return this.phone == '#{login}' || this.email == '#{login}'}")
  end
  
  def email_required?
    false
  end
  
  def will_save_change_to_email?
    false
  end
  
  def self.user_based_scope(user, params={})
    custom_scope = {}
    if user.role?('crm') || user.role?('pos') || user.role?('pos_manager')
      custom_scope = {role: {"$in": 'user'}}
    elsif user.role?("user")
      custom_scope = {id: user.id}
    end
    custom_scope
  end

  private
  def valid_manage_company_ids
    self.errors.add :manage_company_ids, ' must be blank' if ['company_admin', 'user'].include?(role) && manage_company_ids.present?
    self.errors.add :manage_company_ids, ' cannot be blank' if ['crm', 'pos'].include?(role) && manage_company_ids.blank?
  end
end
