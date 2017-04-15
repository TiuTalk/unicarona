class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  before_action :require_phone_confirmation

  private

  def require_phone_confirmation
    return unless current_user.present?
    redirect_to(new_phone_confirmation_path, alert: 'Precisamos confirmar seu número de telefone') unless current_user.phone_confirmed?
  end
end
