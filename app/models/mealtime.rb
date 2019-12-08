class Mealtime
  include Mongoid::Document
  include Mongoid::Timestamps
  include ArrayBlankRejectable
  
  field :name, type: String
  field :start_hour, type: Integer, default: 0
  field :start_minute, type: Integer, default: 0
  field :end_hour, type: Integer, default: 23
  field :end_minute, type: Integer, default: 59
  field :slug, type: String
  field :status, type: String, default: 'active'
  
  has_many :products
  
  validates :name, :status, presence: true
  validates :name, uniqueness: true, allow_blank: true
  validates :status, inclusion: {in: Proc.new{ Category.available_statuses.collect{|x| x[:id]} } }, allow_blank: true
  validates :start_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :end_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :start_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
  validates :end_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }

  def self.available_statuses
    [
      {id: "active", text: "Available"},
      {id: "inactive", text: "Not Available"}
    ]
  end
end
