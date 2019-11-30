class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address1, type: String
  field :address2, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String
  field :zip, type: String
  field :address_type, type: String #TODO: Must be personal, work etc
  field :selldo_id, type: String

  belongs_to :addressable, polymorphic: true, optional: true

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
end
