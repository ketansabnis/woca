class DashboardPolicy < Struct.new(:user, :dashboard)
    def index?
        true
    end

    def faqs?
        true
    end
end
  