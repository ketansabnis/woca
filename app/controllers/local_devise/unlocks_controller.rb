class LocalDevise::UnlocksController < Devise::UnlocksController

  private

  def after_unlock_path_for(resource)
    ApplicationLog.user_log(resource.id, 'unlocked', RequestStore.store[:logging])
    new_session_path(resource)
  end

end
