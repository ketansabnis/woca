require 'autoinc'
class Company
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Autoinc
    include ArrayBlankRejectable
    
    field :name, type: String
    field :industry, type: String
    field :description, type: String
    field :company_id, type: Integer
    field :company_code, type: String
    field :status, type: String

    has_many :users
    has_one :logo, class_name: 'Asset', as: :assetable
    
    validates :name, :status, presence: true
    validates :name, length: {minimum: 4}
    validates :status, inclusion: {in: Proc.new{ Company.available_statuses.collect{|x| x[:id]} } }, allow_blank: true

    increments :company_id
  
    def self.available_statuses
      [
        {id: "active", text: "Active", default: true},
        {id: "inactive", text: "Inactive"}
      ]
    end
  end
  