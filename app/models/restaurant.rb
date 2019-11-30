require 'autoinc'
class Restaurant
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Autoinc
    include ArrayBlankRejectable
    
    field :name, type: String
    field :slug, type: String
    field :email, type: String, default: ""
    field :phone, type: String, default: ""
    field :restaurant_id, type: Integer
    field :restaurant_code, type: String
    field :status, type: String
    field :description, type: String

    has_many :users
    has_one :restaurant_setting
    has_many :restaurant_open_hours, class_name: 'RestaurantOpenHours'
    has_one :address
    has_one :logo, class_name: 'Asset', as: :assetable
    
    validates :name, :status, presence: true
    validates :name, length: {minimum: 4}
    validates :phone, allow_blank: true, phone: { possible: true, types: [:voip, :personal_number, :fixed_or_mobile]}
    validates :status, inclusion: {in: Proc.new{ Restaurant.available_statuses.collect{|x| x[:id]} } }, allow_blank: true
    validate :daily_restaurant_open_hours

    increments :restaurant_id
  
    def self.available_statuses
      [
        {id: "active", text: "Active", default: true},
        {id: "inactive", text: "Inactive"}
      ]
    end

    private
    def daily_restaurant_open_hours
        self.errors.add :restaurant_open_hours, ' not valid' if restaurant_open_hours.count != 7 && (restaurant_open_hours.distinct(:day) - (0..6).to_a).length != 0
    end
  end
  