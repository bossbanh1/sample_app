class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.page_num
  end

  def show
    @microposts = find_user.microposts.paginate page: params[:page],
                    per_page: Settings.page_num
    return if find_user
    flash[:danger] = t "error_user"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_mail"
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "update_succ"
      redirect_to @user
    else
      flash[:danger] = t "update_fails"
      render :edit
    end
  end

  def edit; end

  def destroy
    find_user.destroy
    flash[:success] = t "del_user"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    @user = User.find_by id: params[:id]

    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
  end
end
