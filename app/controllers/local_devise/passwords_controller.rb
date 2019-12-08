class LocalDevise::PasswordsController < Devise::PasswordsController

  private

  def after_resetting_password_path_for(resource)
    ApplicationLog.user_log(resource.id, 'password', RequestStore.store[:logging])
    stored_location_for(resource) || signed_in_root_path(resource)
  end

end
