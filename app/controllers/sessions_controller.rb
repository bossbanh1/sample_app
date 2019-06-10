class SessionsController < ApplicationController
  before_action :find_user, only: :create
  def new; end

  def create
    if @user&.authenticate(params[:session][:password])
      log_in @user
      rem_me = params[:session][:remember_me]
      rem_me == Settings.num ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = t "error_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def find_user
    @user = User.find_by email: params[:session][:email].downcase
  end
end
