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

  def destroy
    @reply = Reply.find(params[:id])
    @article = @reply.comment.article
    if current_user.id == @article.user_id
      @reply.destroy
      flash[:notice] = '已成功删除该回复'
      redirect_to user_article_path(@article.user.name, @article.id)
    else
      flash[:alert] = '你没有足够权限'
      redirect_to user_article_path(@article.user.name, @article.id)
    end
  end
end
