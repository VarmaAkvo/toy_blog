class RelationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @following = current_user.following.with_attached_avatar.page(params[:page]).per_page(30)
  end

  def create
    followed = User.find(params[:user_id])
    current_user.follow followed
    redirect_to user_articles_path(followed.name)
  end

  def destroy
    followed = User.find(params[:user_id])
    current_user.unfollow followed
    redirect_to user_articles_path(followed.name)
  end
end
