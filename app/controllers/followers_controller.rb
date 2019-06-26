class FollowersController < ApplicationController
  before_action :find_user, only: :index

  def index
    @title = t "followers"
    @users = @user.followers.paginate page: params[:page],
             per_page: Settings.page_num
    render "users/show_follow"
  end

  private

  def find_user
    @user = User.find_by id: params[:user_id]
  end
end
