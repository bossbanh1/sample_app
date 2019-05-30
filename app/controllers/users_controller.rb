class UsersController < ApplicationController
  def show
    return if current_user
      flash[:danger] = t "error_user"
      redirect_to root_path

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "welcome"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def current_user
    @user = User.find_by id: params[:id]
  end
end
