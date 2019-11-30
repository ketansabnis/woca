class Configuration
    include Mongoid::Document
    include Mongoid::Timestamps
    include ArrayBlankRejectable
    
    field :name, type: String
    field :tagline, type: String
    field :helpdesk_number, type: String
    field :helpdesk_email, type: String
    field :notification_emails, type: Array
    field :notification_numbers, type: Array
    field :sender_email, type: String
    field :website_link, type: String
    field :disclaimer, type: String
    field :preferred_login, type: String, default: "phone"
    field :mixpanel_token, type: String
    field :sms_provider_username, type: String
    field :sms_provider_password, type: String
    field :sms_mask, type: String, default: "SellDo"
    field :mailgun_private_api_key, type: String
    field :mailgun_email_domain, type: String
    field :payment_gateway, type: String, default: 'Razorpay'
    field :terms_and_conditions, type: String
    field :ga_code, type: String
    field :gtm_tag, type: String
    field :enable_communication, type: Hash, default: {"email": true, "sms": true}
    field :enable_referral_bonus, type: Boolean, default: false
    field :email_header, type: String, default: '<div class="container">
    <img class="mx-auto mt-3 mb-3" maxheight="65" src="<%= app_configuration.logo.url %>" />
    <div class="mt-3"></div>'
  field :email_footer, type: String, default: '<div class="mt-3"></div>
    <div class="card mb-3">
      <div class="card-body">
        Thanks,<br/>
        <%= app_configuration.name %>
      </div>
    </div>
    <div style="font-size: 12px;">
      If you have any queries you can reach us at <%= app_configuration.helpdesk_number %> or write to us at <%= app_configuration.helpdesk_email %>. Please click <a href="<%= app_configuration.website_link %>">here</a> to visit our website.
    </div>
    <hr/>
    <div class="text-muted text-center" style="font-size: 12px;">
      © <%= Date.today.year %> <%= app_configuration.name %>. All Rights Reserved.
    </div>
    <% if app_configuration.address.present? %>
      <div class="text-muted text-center" style="font-size: 12px;">
        <%= app_configuration.address.to_sentence %>
      </div>
    <% end %>
    <div class="mt-3"></div>
  </div>'

  mount_uploader :logo, DocUploader
  mount_uploader :mobile_logo, DocUploader
  mount_uploader :background_image, DocUploader
  
  has_one :address, as: :addressable

  validates :name, :helpdesk_email, :helpdesk_number, :notification_emails, :notification_numbers, :sender_email, :website_link, :payment_gateway, :mailgun_private_api_key, :mailgun_email_domain, :sms_provider_username, :sms_provider_password, :sms_mask, presence: true
  validates :preferred_login, inclusion: {in: Proc.new{ Configuration.available_preferred_logins.collect{|x| x[:id]} } }
  validates :payment_gateway, inclusion: {in: Proc.new{ Configuration.available_payment_gateways.collect{|x| x[:id]} } }, allow_blank: true
  validates :ga_code, format: {with: /\Aua-\d{4,9}-\d{1,4}\z/i, message: 'is not valid'}, allow_blank: true

  accepts_nested_attributes_for :address

  def self.available_preferred_logins
    [
      {id: 'phone', text: 'Phone Based'},
      {id: 'email', text: 'Email Based'}
    ]
  end

  def self.available_payment_gateways
    [
      {id: "Razorpay", text: "Razorpay Payment Gateway"}
    ]
  end

  def sms_enabled?
    self.enable_communication["sms"]
  end

  def email_enabled?
    self.enable_communication["email"]
  end

  def short_name
    'WOCA'
  end
end  

=begin
c = Configuration.new
c.name = "WoCa"
c.tagline = "Eat. Work. Repeat"
c.helpdesk_number = "+91 9552523663"
c.helpdesk_email = "ketan.sabnis@gmail.com"
c.notification_emails = ["ketan.sabnis@gmail.com", "vinaykatkar@gmail.com"]
c.notification_numbers = ["+91 9552523663", "+91 9011099941"]
c.sender_email = "no-reply@woca.life"
c.website_link = "https://www.woca.life"
c.disclaimer = ""
c.preferred_login = "phone"
c.mixpanel_token = ""
c.sms_mask = "WOCALF"
c.mailgun_private_api_key = "f57a396dad8ac77d6accbff906c9e9ca-2416cf28-43e6265c"
c.mailgun_email_domain = "sandbox40e2a6f8f953438b8735e0a9ee0e2123.mailgun.org"
c.payment_gateway = "Razorpay"
c.terms_and_conditions = ""
c.sms_provider_username = "amuramarketing"
c.sms_provider_password = "aJ_Z-1j4"

u = User.new
u.first_name = 'Ketan'
u.last_name = 'Sabnis'
u.display_name = 'Ketan'
u.gender = 'male'
u.married = true
u.dob = Date.parse('29/09/1987')
u.role = 'user'
u.deparment = 'Management'
u.job_title = 'COO'
u.manager_name = 'Vinayak Katkar'
u.manager_email = 'vinayak@amuratech.com'
u.manager_phone = '+919011099941'
u.is_active = true
u.company = 'Amura'
u.employee_id = 'E2'
u.email = 'ketan@amuratech.com'
u.phone = '+919552523663'
u.password = 'amura123'
=end