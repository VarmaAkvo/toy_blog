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
end
