class CategoryObserver < Mongoid::Observer
    include ApplicationHelper

    def before_save category
        category.slug = category.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') if category.name.present? && category.name_changed?
    end
end