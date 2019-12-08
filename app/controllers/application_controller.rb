class ApplicationController < ActionController::Base
  include ApplicationConcern
  include Pundit
  include ApplicationHelper

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_headers, :set_request_store
  before_action :set_current_restaurant

  # acts_as_token_authentication_handler_for User, if: :token_authentication_valid_params?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :home_path
  protect_from_forgery with: :exception, prepend: true

  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_authenticity_token

  def after_sign_in_path_for(current_user)
    # ApplicationLog.user_log(current_user.id, 'sign_in', RequestStore.store[:logging])
    dashboard_path
  end

  def home_path(current_user)
    if current_user
      return dashboard_path
    else
      return root_path
    end
  end

  protected

  def set_current_restaurant
    unless current_restaurant
      redirect_to welcome_path, alert: t('controller.application.set_current_restaurant')
    end
  end
  
  def set_request_store
    if user_signed_in?
      hash = {
        user_id: current_user.id,
        user_email: current_user.email,
        role: current_user.role,
        url: request.url,
        ip: request.remote_ip,
        user_agent: request.user_agent,
        method: request.method,
        request_id: request.request_id,
        timestamp: Time.now
      }
      RequestStore.store[:logging] = hash
    end
  end

  def set_cache_headers
    if user_signed_in?
      response.headers["Cache-Control"] = "no-cache, no-store"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :email, :password, :manager_id, :campaign, :source, :sub_source, :medium, :term])
    devise_parameter_sanitizer.permit(:otp, keys: [:login, :login_otp, :password, :password_confirmation, :manager_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone, :email, :password, :password_confirmation, :current_password, :manager_id])
  end

  def token_authentication_valid_params?
    params[:user_email].present? && params[:user_token].present?
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore.split("/").join('.')
    policy_name += "."
    policy_name += exception.query.to_s
    if exception.policy.condition
      policy_name += "."
      policy_name += exception.policy.condition.to_s
    end
    alert = t policy_name, scope: "pundit", default: :default
    respond_to do |format|
      unless request.referer && request.referer.include?('remote-state') && request.method == 'GET'
        format.html { redirect_to (user_signed_in? ? after_sign_in_path_for(current_user) : root_path), alert: alert }
        format.json { render json: { errors: alert }, status: 403 }
      else
        # Handle response for remote-state url requests.
        format.html do
          render plain: '
            <div class="modal fade right fixed-header-footer" role="dialog" id="modal-remote-form-inner">
              <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                  <div class="modal-header bg-gradient-cd white">
                    <h3 class="title">' + params[:controller].titleize + '</h3>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true" class="white">&times;</span>
                    </button>
                  </div>
                  <div class="modal-body">' + alert + '</div>
                  <div class="modal-footer"></div>
                </div>
              </div>
            </div>'
        end
      end
    end
  end

  def invalid_authenticity_token
    alert = t('controller.application.invalid')
    respond_to do |format|
      format.html { render json: alert }
      format.json { render json: { errors: alert }, status: 403 }
    end
  end

  # For VAPT we want to protect Site with ony permited origins
  def valid_request_origin? # :doc:
    _valid = super

    _valid && ( (current_restaurant.try(:booking_portal_domains) || []).include?( URI.parse( request.origin.to_s ).host ) || Rails.env.development? || Rails.env.test? )
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
