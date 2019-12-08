class Admin::CompanyPolicy < CompanyPolicy
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

  def export?
    update?
  end

  def permitted_attributes(params = {})
    attributes = super
    attributes += [:name,:industry,:description,:company_id,:company_code,:status,:preferred_login,:enable_communication]
    attributes.uniq
  end
end
