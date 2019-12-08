class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include ArrayBlankRejectable
  
  field :name, type: String
  field :description, type: String
  field :slug, type: String
  field :status, type: String, default: 'active'

  has_many :products
  belongs_to :category, optional: true
  has_and_belongs_to_many :restaurants
  has_one :asset, as: :assetable

  validates :name, :status, presence: true
  validates :name, uniqueness: true, allow_blank: true
  validates :status, inclusion: {in: Proc.new{ Category.available_statuses.collect{|x| x[:id]} } }, allow_blank: true

  def self.available_statuses
    [
      {id: "active", text: "Available"},
      {id: "inactive", text: "Not Available"}
    ]
  end
end
