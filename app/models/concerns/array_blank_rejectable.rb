module ArrayBlankRejectable
    extend ActiveSupport::Concern
    included do
        self.before_validation do |model|
            self.fields.select{|_, field| field.type == Array}.each do |key, field|
                if model.send(key).present?
                    model.send("#{key}=",Array.wrap(model.send(key)).reject(&:blank?).uniq)
                end
            end
        end
    end
end