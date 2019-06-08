class Search::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: :following
  def index
    @articles =  Article.paginate_by_sql([<<-SQL , query: params[:query]], page: params[:page], per_page: 10)
      SELECT a.* FROM articles a
      WHERE to_tsvector('english', title || ' ' || COALESCE(striped_tags_content, ' ')
                          || ' ' || COALESCE(tag_list, ' ')
                         ) @@ websearch_to_tsquery(:query)
      ORDER BY ts_rank((setweight(to_tsvector(title), 'A') ||
                        to_tsvector(COALESCE(striped_tags_content, ' ')) ||
                        setweight(to_tsvector(COALESCE(tag_list, ' ')), 'B')
                       ), websearch_to_tsquery(:query)
                      ) DESC
    SQL
    # 预加载用户头像
    ActiveRecord::Associations::Preloader.new.preload(@articles, [:rich_text_content, user: :avatar_attachment])
  end

  def recent
    @articles = Article.with_rich_text_content_and_embeds
                       .includes(user: :avatar_attachment)
                       .order(created_at: :desc).page(params[:page]).per_page(10)
  end

  def following
    @articles = Article.with_rich_text_content_and_embeds
                       .includes(user: :avatar_attachment)
                       .where(user_id: current_user.following_ids)
                       .order(created_at: :desc).page(params[:page]).per_page(10)
  end
end
