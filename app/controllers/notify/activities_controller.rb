class Notify::ActivitiesController < Notify::ApplicationController
  def index
    @activities = Article.includes(:user).where(user_id: current_user.following_ids).order(created_at: :desc)
                         .page(params[:page]).per_page(10)
  end

  private

  def update_visit_time
    @activity_last_visit.touch
  end
end
