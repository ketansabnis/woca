class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address1, type: String
  field :address2, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String
  field :zip, type: String
  field :address_type, type: String, default: 'primary'

  belongs_to :addressable, polymorphic: true, optional: true

  validates :address_type, inclusion: {in: Proc.new{ Address.available_address_types.collect{|x| x[:id]} } }, allow_blank: true

  def ui_json
    to_json
  end

  def to_sentence
    str = "#{self.address1}"
    str += " #{self.address2}," if self.address2.present?
    str += " #{self.city}," if self.city.present?
    str += " #{self.state}," if self.state.present?
    str += " #{self.country}," if self.country.present?
    str += " #{self.zip}," if self.zip.present?
    str.strip!
    str.present? ? str : "-"
  end

  def self.available_address_types
    [
      {id: "primary", text: "Primary", default: true},
      {id: "personal", text: "Personal"},
      {id: "work", text: "Work"}
    ]
  end
end
