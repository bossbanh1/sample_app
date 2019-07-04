class PasswordResetsController < ApplicationController
  before_action :find_user, only: :create
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    if @user
      @user.create_reset_digest
      @user.sent_password_reset_email
      flash[:info] = t "mail_pass"
      redirect_to root_url
    else
      flash[:danger] = t "mail_not"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("not_emp")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t("pass_been")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def find_user
    @user = User.find_by email: params[:password_reset][:email].downcase
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "exprired_pass"
    redirect_to new_password_reset_url
  end
end
