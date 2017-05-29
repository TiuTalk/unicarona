class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  before_action :store_device_token
  before_action :require_phone_confirmation, if: :signed_in?

  private

  def require_phone_confirmation
    redirect_to(new_phone_confirmation_path, alert: 'Precisamos confirmar seu número de telefone') unless current_user.phone_confirmed?
  end

  def store_device_token
    session[:device_token] = request.headers['HTTP_DEVICETOKEN'] if request.headers['HTTP_DEVICETOKEN'].present?
    current_user.update(device_token: session[:device_token]) if signed_in? && session[:device_token].present?
  end
end
