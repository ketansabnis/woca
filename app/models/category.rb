class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include ArrayBlankRejectable
  
  field :name, type: String
  field :slug, type: String
  field :status, type: String

  has_many :products

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
