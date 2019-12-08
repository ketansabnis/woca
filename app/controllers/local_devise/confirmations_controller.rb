# app/controllers/confirmations_controller.rb
class LocalDevise::ConfirmationsController < Devise::ConfirmationsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  # skip_before_filter :require_no_authentication
  # skip_before_filter :authenticate_user!
  before_action :redirect_if_logged_in

  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        @confirmable.attempt_set_password(params[:user])
        if @confirmable.valid? and @confirmable.password_match?
          do_confirm
        else
          do_show
          @confirmable.errors.clear #so that we wont render :new
        end
      else
        @confirmable.errors.add(:email, :password_already_set)
      end
    end

    if !@confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new' #Change this if you don't have the views on default path
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    unless @confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new' #Change this if you don't have the views on default path
    end
  end

  protected

  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'devise/confirmations/show' #Change this if you don't have the views on default path
  end

  def do_confirm
    @confirmable.confirm
    if params[:manager_id].present?
      @confirmable.manager_id = params[:manager_id]
      @confirmable.referenced_manager_ids = ([params[:manager_id]] + @confirmable.referenced_manager_ids).uniq
      @confirmable.manager_change_reason = "Customer confirmed with link sent by #{@confirmable.manager.name}"
      @confirmable.save
    end
    SelldoLeadUpdater.perform_async(@confirmable.id, 'confirmed')
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end

  private
  def after_confirmation_path_for(resource_name, resource)
    ApplicationLog.user_log(resource.id, 'confirmed', RequestStore.store[:logging])
    new_session_path(resource_name)
  end

  def after_confirmation_set_password_path_for(token)
    ApplicationLog.user_log(resource.id, 'confirmed', RequestStore.store[:logging])
    edit_user_password_path(reset_password_token: token)
  end

  private
  def redirect_if_logged_in
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end
