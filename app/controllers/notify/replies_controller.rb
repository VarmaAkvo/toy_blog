class Notify::RepliesController < ApplicationController
  before_action :authenticate_user!

  def index
    @replies = Reply.includes(:user, comment: {article: :user}).where(comment_id: current_user.comment_ids).order(created_at: :desc)
                         .page(params[:page]).per_page(10)
  end
end
