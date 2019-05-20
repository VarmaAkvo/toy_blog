class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_article, except: [:new, :create, :show, :index]
  before_action :set_owner, only: [:index, :show]
  before_action :confirm_authority, only: [:edit, :update, :destroy]

  def index
    # 当前with_rich_text_content_and_embeds并不能解决N+1问题， 留着等修复
    @articles = @owner.articles.includes(:tags).with_rich_text_content_and_embeds.order(created_at: :desc)
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.with_rich_text_content_and_embeds.find(params[:id])
    @pre_article = @owner.articles.where("created_at < ?", @article.created_at).order(:created_at).last
    @next_article = @owner.articles.where("created_at > ?", @article.created_at).order(:created_at).first
  end

  def edit
    @article.tag_list = @article.tags.pluck(:name).join(' ')
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save_with_tags(params[:article][:tag_list])
      #add_tags_to(@article, params[:article][:tag_list]) unless params[:article][:tag_list].empty?
      flash[:notice] = "新文章发布成功。"
      redirect_to user_article_url(current_user.name, @article)
    else
      render 'new'
    end
  end

  def update
    if @article.update_with_tags(params[:article][:tag_list], article_params)
      #update_tags_for(@article, params[:article][:tag_list]) unless params[:article][:tag_list].empty?
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

  def add_tags_to(taggable, tags)
    # 去除重复tag
    valid_tags = tags.split.uniq
    valid_tags.each do |tag|
      # 如果是数据库中不存在的tag 则创建它
      Tag.create(name: tag) unless Tag.exists?(name: tag)
    end
    # 创建tagging 关联
    tag_ids = Tag.where(name: valid_tags).pluck(:id)
    tag_ids.each do |tag_id|
      taggable.tagging.create(tag_id: tag_id)
    end
  end

  def update_tags_for(taggable, tags)
    # 去除重复tag
    valid_tags = tags.split.uniq.join(' ')
    # 删除所有tagging
    taggable.tagging.each do |tagging|
      tagging.destroy
      # 如果一个tag不再被tagging就删除它
      if Tagging.exists?( tag_id: tagging.tag_id)
        Tag.destroy(tagging.tag_id)
      end
    end
    add_tags_to(taggable, valid_tags)
  end
end
