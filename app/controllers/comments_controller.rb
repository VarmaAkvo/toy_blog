class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(user_id: current_user.id, content: params[:comment][:content])
    floor = (@article.comments.maximum(:floor) || 0) + 1
    @comment.floor = floor
    if @comment.save
      flash[:notice] = '评论成功'
      redirect_to user_article_path(@article.user.name, @article.id)
    else
      flash[:alert] = '评论不能为空'
      redirect_to user_article_path(@article.user.name, @article.id)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @article = @comment.article
    if current_user.id == @article.user_id
      @comment.destroy
      flash[:notice] = '已成功删除该评论'
      redirect_to user_article_path(@article.user.name, @article.id)
    else
      flash[:alert] = '你没有足够权限'
      redirect_to user_article_path(@article.user.name, @article.id)
    end
  end
end
