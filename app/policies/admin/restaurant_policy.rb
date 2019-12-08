class Admin::RestaurantPolicy < RestaurantPolicy
  def update?
    %w[admin].include?(user.role)
  end

  def asset_create?
    update?
  end

  def index?
    update?
  end

  def create?
    update?
  end

  def permitted_attributes(params = {})
    attributes = super
    attributes += [:name, :slug, :email, :phone, :restaurant_id, :restaurant_code, :status, :description, :web_domain]
    attributes.uniq
  end
end
