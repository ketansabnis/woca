class Asset
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :file, AssetUploader

  field :file_size, type: Integer
  field :file_name, type: String
  field :asset_type, type: String
  field :document_name, type: String

  belongs_to :assetable, polymorphic: true

  validates :file_name, uniqueness: { scope: [:assetable_type, :assetable_id] }
end
