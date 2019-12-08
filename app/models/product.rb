class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include ArrayBlankRejectable
  
  field :name, type: String
  field :description, type: String
  field :status, type: String, default: "available"
  field :price, type: Money
  field :pos_reference_id, type: String
  field :minimum_preparation_time, type: Integer # In seconds
  field :minimum_quantity, type: Integer, default: 1
  field :stock_quantity, type: Integer, default: 0 # 0 indicates no limit
  field :subtract_stock, type: Boolean, default: false

  belongs_to :category
  belongs_to :mealtime
  has_one :asset, as: :assetable
  has_and_belongs_to_many :restaurants

  validates :name, :status, :price, :minimum_quantity, :stock_quantity, presence: true
  validates :name, uniqueness: true, allow_blank: true
  validates :status, inclusion: {in: Proc.new{ Product.available_statuses.collect{|x| x[:id]} } }, allow_blank: true
  validates :minimum_quantity, :minimum_preparation_time, numericality: {greater_than: 0}, allow_blank: true
  validates :stock_quantity, numericality: {greater_than_or_equal_to: 0}, allow_blank: true

  def self.available_statuses
    [
      {id: "available", text: "Available"},
      {id: "not_available", text: "Not Available"},
      {id: "sold", text: "Sold"}
    ]
  end
end
