class RestaurantObserver < Mongoid::Observer
  include ApplicationHelper

  def before_validation restaurant
    if restaurant.restaurant_open_hours.count != 7 && (restaurant.restaurant_open_hours.distinct(:day) - (0..6).to_a).length != 0
      (0..6).to_a.each do |day|
        restaurant.restaurant_open_hours << RestaurantOpenHours.new(day: day)
      end
    end
    restaurant.restaurant_setting = RestaurantSetting.new if restaurant.restaurant_setting.blank?
  end

  def after_create restaurant
    restaurant.set(restaurant_code: "#{restaurant.name.tr('^A-Za-z', '')[0..4].upcase}_#{restaurant.restaurant_id}") if restaurant.restaurant_code.blank?
  end
end
