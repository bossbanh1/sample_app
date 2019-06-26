class FollowingController < ApplicationController
  before_action :find_user, only: :index

  def index
    @title = t "following"
    @users = @user.following.paginate page: params[:page],
             per_page: Settings.page_num
    render "users/show_follow"
  end

  def show; end

  private

  def find_user
    @user = User.find_by id: params[:user_id]
  end
end
