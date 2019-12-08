class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :only_administrator_users!

  private

   #
   # Admin controller is only for administrator users.
   #
   #
   def only_administrator_users!
    if current_user && !current_user.role?('admin')
      redirect_to dashboard_path, alert: t('controller.only_administrator_users')
    end
   end
end
