class Email
  include Mongoid::Document
  include Mongoid::Timestamps
  extend FilterByCriteria

  # Scopes
  scope :filter_by_to, ->(email) { where(to: email) }
  scope :filter_by_cc, ->(email) { where(cc: email) }
  scope :filter_by_sent_on, ->(date) { start_date, end_date = date.split(' - '); where(sent_on: start_date..end_date) }
  scope :filter_by_subject, ->(subject) { where(subject: ::Regexp.new(::Regexp.escape(subject), 'i')) }
  scope :filter_by_body, ->(body) { where(body: ::Regexp.new(::Regexp.escape(body), 'i')) }
  scope :filter_by_status, ->(status) { where(status: status) }

  # Fields
  field :to, type: Array
  field :cc, type: Array
  field :subject, type: String
  field :body, type: String
  field :text_only_body, type: String
  field :status, type: String, default: "draft"
  field :remote_id, type: String
  field :sent_on, type: DateTime
  field :email_thread_id, type: BSON::ObjectId #set only when there's an email conversation. maintains the id of previous email in the thread

  # Validations
  validates :subject, presence: true, if: Proc.new{ |model| model.email_template_id.blank? }
  validates :recipient_ids, :triggered_by_id, presence: true
  validate :body_or_text_only_body_present?
  validates_inclusion_of :status, in: Proc.new {  self.allowed_statuses.collect{ |hash| hash[:id] } }

  # Associations
  belongs_to :email_template, class_name: 'Template::EmailTemplate', optional: true
  has_and_belongs_to_many :recipients, class_name: "User", inverse_of: :received_emails, validate: false
  has_and_belongs_to_many :cc_recipients, class_name: "User", inverse_of: :cced_emails, validate: false
  belongs_to :triggered_by, polymorphic: true, optional: true
  has_many :attachments, as: :assetable, class_name: "Asset"
  accepts_nested_attributes_for :attachments

  default_scope -> {desc(:created_at)}

  # Methods

  # returns array having statuses, which are allowed on models
  # allowed statuses are used in select2 for populating data on UI side. they also help in validations
  #
  # @return [Array] of hashes
  def self.allowed_statuses
    [
      {id: "draft",text: "Draft", default: true},
      {id: "scheduled", text: "Scheduled"},
      {id: "queued", text: "Queued"},
      {id: "sent", text: "Sent"},
      {id: "delivered", text: "Delivered"},
      {id: "read", text: "Read"},
      {id: "unread", text: "Unread"},
      {id: "clicked", text: "Clicked"},
      {id: "bounced", text: "Bounced"},
      {id: "dropped", text: "Dropped"},
      {id: "spam", text: "Spam"},
      {id: "complained", text: "Complained"},
      {id: "unsubscribed",text: "Unsubscribed"},
      {id: "untracked",text: "Untracked"}
    ]
  end

  # returns the boolean status of email entity, whether it is in draft / untracked stage
  #
  # @return [Boolean]
  def not_draft_or_untracked
    status != "draft" || status != "untracked"
  end

  # returns the subject if email entity
  #
  # @return [String]
  def name
    self.subject
  end

  private

  # for email template we require body or text. Otherwise we won't have any content to send to the sender / reciever
  # throws error if the both are blank
  #
  def body_or_text_only_body_present?
    if self.email_template_id.blank?
      if self.body.blank? && self.text_only_body.blank?
        self.errors.add(:base,"Either html-body or text only content is required.")
      end
    end
  end
end
