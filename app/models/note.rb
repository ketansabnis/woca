class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :note, type: String
  field :note_type, type: String, default: :internal

  belongs_to :notable, polymorphic: true
  has_many :assets, as: :assetable
  belongs_to :creator, class_name: 'User'

  default_scope -> {desc(:created_at)}

  validates :note, presence: true

  def self.available_note_types
    [
      {id: "internal", text: "Internal"},
      {id: "user", text: "Customer"}
    ]
  end
end
