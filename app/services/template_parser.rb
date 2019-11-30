module TemplateParser
  def self.parse(content, object, options = {})
    ignore_empty_insertion = options[:ignore_empty_insertion].present? ? options[:ignore_empty_insertion] : false
    content ||= ""
    content.scan(/(\{\{[\s\n\S]+?\}\})/).flat_map do |insertion_string|
      insertion_value = object.parse_insertion_string(insertion_string.first.gsub("{{","").gsub("}}","").gsub(/\s+/,""))
      if insertion_value.blank?
        if !ignore_empty_insertion
          content.gsub!(insertion_string.first,insertion_value.to_s)
        end
      else
        content.gsub!(insertion_string.first,insertion_value.to_s)
      end
    end
    content.html_safe
  end
end
