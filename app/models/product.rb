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

  belongs_to :category

  validates :name, :status, :price, :pos_reference_id, presence: true
  validates :name, uniqueness: true, allow_blank: true
  validates :status, inclusion: {in: Proc.new{ Product.available_statuses.collect{|x| x[:id]} } }, allow_blank: true

  def self.available_statuses
    [
      {id: "available", text: "Available"},
      {id: "not_available", text: "Not Available"},
      {id: "sold", text: "Sold"}
    ]
  end
end
