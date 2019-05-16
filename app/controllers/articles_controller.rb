class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_article, except: [:new, :create, :show]
  before_action :confirm_authority, only: [:edit, :update, :destroy]

  def new
    @article = Article.new
  end

  def show
    @article = Article.with_rich_text_content_and_embeds.find(params[:id])
    @owner   = @article.user
    @pre_article = @owner.articles.where("created_at < ?", @article.created_at).order(:created_at).last
    @next_article = @owner.articles.where("created_at > ?", @article.created_at).order(:created_at).first
  end

  def edit
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      flash[:notice] = "新文章发布成功。"
      redirect_to user_article_url(current_user.name, @article)
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      flash[:notice] = "文章更新成功。"
      redirect_to user_article_url(current_user.name, @article)
    else
      render 'edit'
    end
  end

  def destroy
    flash[:notice] = "该文章已经删除。"
    @article.destroy
    redirect_to root_url
  end

  private

  def set_article
    @article ||= Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end

  def confirm_authority
    # 只有当前文章的所有者才拥有修改、删除的权限
    @article ||= Article.find(params[:id])
    if params[:name].downcase != current_user.name
      flash[:alert] = '你没有权限进行该操作'
      redirect_to root_url
    end
  end
end
