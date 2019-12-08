module ApplicationHelper
  def global_labels
    t('global').with_indifferent_access
  end
  
  def global_label(key, params={})
    t("global.#{key}", params)
  end
  
  def number_to_indian_currency(number)
    if number
      string = number.to_s.split('.')
      number = string[0].gsub(/(\d+)(\d{3})$/){ p = $2;"#{$1.reverse.gsub(/(\d{2})/,'\1,').reverse},#{p}"}
      number = number.gsub(/^,/, '')
      number = number + '.' + string[1] if string[1].to_f > 0
    end
    "&#8377;#{number}".html_safe
  end
  
  def app_configuration
    Configuration.first
  end
  
  def current_restaurant
    return @current_restaurant if @current_restaurant.present?
    if Rails.env.development?
      @current_restaurant = Restaurant.asc(:created_at).first
    else
      if defined?(request) && request && request.subdomain.present? && request.domain.present?
        domain = (request.subdomain.present? ? "#{request.subdomain}." : "") + "#{request.domain}"
        @current_restaurant = Restaurant.in(booking_portal_domains: domain).first
      end
    end
    @current_restaurant
  end
  
  def current_company
    return @current_company if @current_company.present?
    @current_company = current_restaurant.company
  end    
end
