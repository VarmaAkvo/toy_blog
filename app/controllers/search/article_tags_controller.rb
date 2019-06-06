class Search::ArticleTagsController < ApplicationController
  def index
    tag = params[:tag]
    # 返回符合条件的文章并按创建时间排列
=begin
    article_ids = Article.joins(:tags).where(tags: {name: tag}).ids
    @articles = Article.where(id: article_ids).includes(:tags, user: :avatar_attachment)
                       .with_rich_text_content_and_embeds
                       .order(created_at: :desc).page(params[:page]).per_page(10)
=end
    @articles = Article.with_tag_strings.includes(user: :avatar_attachment)
                       .with_rich_text_content_and_embeds
                       .where("tag_strings LIKE ?", "%#{tag}%")
                       .order(created_at: :desc).page(params[:page]).per_page(10)
  end
end
