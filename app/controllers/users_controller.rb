# frozen_string_literal: true

# user controller with only teacher access
class UsersController < TeacherController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    user_password = params[:user][:password]

    if @user.save
      redirect_to users_path, flash: { user: @user, pass: user_password }
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    else
      user_password = params[:user][:password]
    end
    if @user.update(user_params)

      redirect_to users_path, flash: { user: @user, pass: user_password }
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
  end

end
