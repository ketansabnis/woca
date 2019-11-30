module FilterByCriteria

  # to apply all filters, to add new filter only add scope in respective model and filter on frontend, new filter parameter must be inside filters hash
  def build_criteria params={}
    params ||= {}
    filters = self.all
    (params[:filters] || {}).each do |key, value|
      if self.respond_to?("filter_by_#{key}") && value.present?
        filters = filters.send("filter_by_#{key}", *value)
      end
    end
    field_name, sort_order = params[:sort].to_s.split(".")
    filters = filters.order_by([ (field_name || :created_at), (sort_order || :desc) ])
    filters
  end
end