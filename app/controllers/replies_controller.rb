class RepliesController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.find(params[:comment_id])
    @reply = @comment.replies.build(user_id: current_user.id, content: params[:reply][:content])
    if @reply.save
      flash[:notice] = '回复成功。'
    else
      flash[:alert] = '回复不能为空'
    end
    redirect_to user_article_path(@comment.article.user.name, @comment.article_id)
  end
end
