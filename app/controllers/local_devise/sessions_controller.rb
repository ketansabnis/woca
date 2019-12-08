class LocalDevise::SessionsController < Devise::SessionsController
  include SessionHelper
  prepend_before_action :require_no_authentication, only: [:otp]
  before_action :redirect_if_logged_in
  before_action :generate_rsa_key, only: :new
  prepend_before_action -> {authenticate_encryptor([:password])}, only: :create
  
  around_action :reset_unique_session, only: :destroy
  
  def create
    if params[self.resource_name][:login_otp].present?
      user = self.resource_class.find_for_database_authentication(params[resource_name])
      if user.present? && user.authenticate_otp(params[self.resource_name][:login_otp], drift: 60)
        self.resource = user
        # Also confirm the user if they have verified the OTP
        unless self.resource.confirmed?
          self.resource.confirm
        end
      else
        throw(:warden, auth_options)
      end
    else
      self.resource = warden.authenticate!(auth_options)
    end
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
  
  def otp
    self.resource = self.resource_class.find_for_database_authentication(sign_in_params)
    respond_to do |format|
      if self.resource
        # TODO: handle max attempts to be 3 in 60 min
        otp_sent_status = self.resource.send_otp
        if Rails.env.development?
          Rails.logger.info "---------------- #{resource.otp_code} ----------------"
        end
        if otp_sent_status[:status]
          format.json { render json: {confirmed: resource.confirmed?, errors: ""}, status: 200 }
        else
          format.json { render json: {errors: otp_sent_status[:error]}, status: 422 }
        end
      else
        format.json { render json: {errors: "Please enter a valid login"}, status: :unprocessable_entity }
      end
    end
  end
  
  protected
  
  # Reset The uniq_session id after sign out.
  def reset_unique_session
    user = instance_variable_get(:"@current_#{resource_name}")
    yield
    user.set(unique_session_id: nil, uniq_user_agent: nil) if instance_variable_get(:"@current_#{resource_name}").blank?
  end
  
  # GENERICTODO: check if this can be handled better. phone with + in param replaced as a space. So need to decode it back
  def sign_in_params
    out = devise_parameter_sanitizer.sanitize(:sign_in)
    if request.get?
      out.each do |key, val|
        out[key] = URI.decode_www_form_component(val)
      end
    end
    out
  end

  private
  def redirect_if_logged_in
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end
