class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :is_active, type: Boolean, default: true

  validates :content, presence: true

  def parsed_content object
    return ERB.new(self.content).result( object.get_binding ).html_safe
  end

  def self.build_criteria params={}
    selector = {}
    if params[:fltrs].present?
      if params[:fltrs][:_type].present?
        selector[:_type] = params[:fltrs][:_type]
      end
    end
    self.where(selector)
  end
end
