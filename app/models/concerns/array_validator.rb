class ArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    valid = true
    if options && options.keys.include?(:if) && options[:if].is_a?(Proc)
      valid = options[:if].call(record)
    end
    if valid
      [values].flatten.each do |value|
        options.reject{|k,v| k.to_s == "if"}.each do |key, args|
          validator_options = { attributes: attribute }
          validator_options.merge!(args) if args.is_a?(Hash)

          next if value.nil? && validator_options[:allow_nil]
          next if value.blank? && validator_options[:allow_blank]

          validator_class_name = "#{key.to_s.camelize}Validator"
          validator_class = begin
            validator_class_name.constantize
          rescue NameError
            "ActiveModel::Validations::#{validator_class_name}".constantize
          end

          validator = validator_class.new(validator_options)
          validator.validate_each(record, attribute, value)
        end
      end
    end
  end
end