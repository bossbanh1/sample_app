class SessionsController < ApplicationController
  before_action :find_user, only: :create
  def new; end

  def create
    return unless @user&.authenticate params[:session][:password]

    if @user.activated?
      log_in @user
      rem_me
      redirect_back_or @user
    else
      message = t "acc_no"
      flash[:warning] = message
      redirect_to root_url
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

  def rem_me
    rem_me = params[:session][:remember_me]
    rem_me == Settings.num ? remember(@user) : forget(@user)
  end
end
