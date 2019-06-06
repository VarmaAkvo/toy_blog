class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_article, except: [:new, :create, :show, :index]
  before_action :set_owner, only: [:index, :show]
  before_action :confirm_authority, only: [:edit, :update, :destroy]
  before_action :is_punished_by_admin?, only: :create

  def index
    # 当前with_rich_text_content_and_embeds并不能解决N+1问题， 留着等修复
    @articles = @owner.articles.with_tag_strings
                      .with_rich_text_content_and_embeds.order(created_at: :desc)
                      .page(params[:page]).per_page(5)
    @uats = UserArticlesTagsStatistic.includes(:tag).where(user_id: @owner.id)
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.with_tag_strings.with_rich_text_content_and_embeds.find(params[:id])
    @uats = UserArticlesTagsStatistic.includes(:tag).where(user_id: @owner.id)
    @pre_article = @owner.articles.where("created_at < ?", @article.created_at).order(:created_at).last
    @next_article = @owner.articles.where("created_at > ?", @article.created_at).order(:created_at).first
    @comment = Comment.new
    @comments = @article.comments
                        .includes(user: :avatar_attachment, replies: {user: :avatar_attachment})
                        .order(created_at: :desc).page(params[:page]).per_page(5)
    @reply = Reply.new
  end

  def edit
    @article.tag_list = @article.tags.pluck(:name).join(' ')
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      @article.create_tags(params[:article][:tag_list]) unless params[:article][:tag_list].empty?
      flash[:notice] = "新文章发布成功。"
      redirect_to user_article_url(current_user.name, @article)
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      # 如果没改tags就不进行更新
      unless params[:article][:tag_list].split.sort == @article.tags.pluck(:name).sort
        @article.update_tags(params[:article][:tag_list])
      end
      flash[:notice] = "文章更新成功。"
      redirect_to user_article_url(current_user.name, @article)
    else
      render 'edit'
    end
  end

  def destroy
    flash[:notice] = "该文章已经删除。"
    @article.delete_tags
    @article.destroy
    redirect_to  user_articles_path(current_user.name)
  end

  private

  def set_article
    @article ||= Article.find(params[:id])
  end

  def set_owner
    # 如果当前文章的所有者就是当前用户则不再做一次查询
    owner_name = params[:name].downcase
    if user_signed_in? && current_user.name == owner_name
      @owner = current_user
    else
      @owner = User.find_by!(name: owner_name)
    end
  end

  def article_params
    params.require(:article).permit(:title, :content, :tag_list).reject {|k, v| k.to_sym == :tag_list}
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
