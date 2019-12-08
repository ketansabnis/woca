class DashboardController < ApplicationController
    before_action :authenticate_user!
  
    def index
      authorize :dashboard, :index?
    end
  
    def faqs
    end

    def terms_and_conditions
    end
    
end