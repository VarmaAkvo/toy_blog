class Notify::ApplicationController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :check_new_notify
  before_action :count_new_notify
  before_action :update_visit_time

  private

  def count_new_notify
    @current_time = Time.now

    @activity_last_visit = ActivityNotifyVisit.find_or_create_by(user_id: current_user.id)
    @comment_last_visit = CommentNotifyVisit.find_or_create_by(user_id: current_user.id)
    @reply_last_visit = ReplyNotifyVisit.find_or_create_by(user_id: current_user.id)

    @activities_count = Article.where(user_id: current_user.following_ids,
          created_at: @activity_last_visit.updated_at..@current_time).count

    @comments_count = Comment.where(article_id: current_user.article_ids,
          created_at: @comment_last_visit.updated_at..@current_time).count
    @replies_count = Reply.where(comment_id: current_user.comment_ids,
          created_at: @reply_last_visit.updated_at..@current_time).count
  end

  def update_visit_time
    #留在子类实现
  end
end
