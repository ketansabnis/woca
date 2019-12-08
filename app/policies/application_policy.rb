class ApplicationPolicy
  include ApplicationHelper

  attr_reader :user, :record, :condition

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def permitted_attributes params={}
    []
  end

  def editable_field? field
    permitted = permitted_attributes.include?(field.to_sym) || permitted_attributes.include?(field.to_s)
    if !permitted
      nested_fields = permitted_attributes.select{|k| k.is_a?(Hash)}
      nested_fields.each do |hash|
        permitted = (hash.keys.include?(field.to_sym) || hash.keys.include?(field.to_s)) if !permitted
      end
    end
    permitted
  end

  def editable_fields
    permitted_fields = permitted_attributes.map do |field|
      field.is_a?(Hash) ? field.keys : field
    end
    permitted_fields.flatten.map(&:to_s)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
