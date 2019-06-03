class Search::BlogTagSearchController < ApplicationController
  def index
    @owner = User.find_by(name: params[:name])
    if @owner.nil?
      flash[:alert] = '该用户不存在'
      redirect_to root_path and return
    end
    tag = params[:tag]
    # 用joins不会预加载关联
    article_ids = @owner.articles.joins(:tags)
                      .where(tags: {name: tag})
                      .order(created_at: :desc).page(params[:page]).per_page(10).ids
    @articles = Article.with_rich_text_content_and_embeds.includes(:tags)
                       .where(id: article_ids)
                       .order(created_at: :desc).page(params[:page]).per_page(10)
    @uats = UserArticlesTagsStatistic.includes(:tag).where(user_id: @owner.id)
  end
end
