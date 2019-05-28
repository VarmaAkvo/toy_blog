class Notify::CommentsController < Notify::ApplicationController
  def index
    @articles = Article.includes(:user).where(user_id: current_user.id).order(updated_at: :desc)
                         .page(params[:page]).per_page(10)
  end

  private

  def update_visit_time
    @comment_last_visit.touch
  end
end
