class PhoneConfirmationsController < ApplicationController
  before_action :require_login
  skip_before_action :require_phone_confirmation

  def new
  end

  def create
    if current_user.update(phone_params)
      current_user.confirm_phone!
      render :confirm
    else
      render :new
    end
  end

  def confirm
    if current_user.confirm_phone?(confirmation_params[:phone_confirmation_code]) && current_user.phone_confirmed?
      redirect_to root_path, notice: 'Seu número foi confirmado com sucesso!'
    else
      render :confirm
    end
  end

  private

  def phone_params
    params.require(:user).permit(:phone)
  end

  def confirmation_params
    params.require(:user).permit(:phone_confirmation_code)
  end
end
