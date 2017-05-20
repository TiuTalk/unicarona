class UsersController < Clearance::UsersController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      redirect_to root_path, notice: "Bem-vindo(a), #{@user.name}"
    else
      render :new
    end
  end

  def store_device_token
    session[:device_token] = params[:token]
    head :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
