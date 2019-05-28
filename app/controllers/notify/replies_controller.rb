class Notify::RepliesController < Notify::ApplicationController
  def index
    @replies = Reply.includes(:user, comment: {article: :user}).where(comment_id: current_user.comment_ids).order(created_at: :desc)
                         .page(params[:page]).per_page(10)
  end

  private

  def update_visit_time
    @reply_last_visit.touch
  end
end
