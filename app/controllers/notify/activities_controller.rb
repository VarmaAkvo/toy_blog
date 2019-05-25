class Notify::ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @activities = Article.includes(:user).where(user_id: current_user.following_ids).order(created_at: :desc)
                         .page(params[:page]).per_page(10)
  end
end