class Search::ArticleTagsController < ApplicationController
  def index
    tag = params[:tag]
    # 返回符合条件的文章并按创建时间排列
    @articles = Article.includes(user: :avatar_attachment)
                       .with_rich_text_content_and_embeds
                       .where("tag_list LIKE ?", "%#{tag}%")
                       .order(created_at: :desc).page(params[:page]).per_page(10)
  end
end
