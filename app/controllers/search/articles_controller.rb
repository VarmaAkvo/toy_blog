class Search::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: :following
  def index
    @articles =  Article.paginate_by_sql([<<-SQL ,params[:query]], page: params[:page], per_page: 10)
      WITH articles_content AS (
        SELECT a.id, atrt.body as content
          FROM articles a, action_text_rich_texts atrt
        WHERE a.id = atrt.record_id AND atrt.record_type = 'Article'
      ), articles_tag_strings AS (
        SELECT string_agg(t.name, ' ') as tag_strings, a.id
      	FROM articles a
      	  LEFT OUTER JOIN tagging tg ON tg.taggable_id = a.id and tg.taggable_type = 'Article'
      	  LEFT OUTER JOIN tags t ON tg.tag_id = t.id
        GROUP BY a.id
      ), articles_with_content_and_tag_strings AS (
        SELECT a.*, ac.content, ats.tag_strings
      	FROM articles a
      	  INNER JOIN articles_content ac ON ac.id = a.id
      	  INNER JOIN articles_tag_strings ats ON ats.id = a.id
      ), vector AS (
        SELECT a.id,
      	     (setweight(to_tsvector(a.title), 'A') ||
      		   to_tsvector(a.content) ||
      		   setweight(to_tsvector(COALESCE(a.tag_strings, '')), 'B')
      	     ) AS tsv
          FROM articles_with_content_and_tag_strings a
      ), query as (
        SELECT websearch_to_tsquery(?) AS tsq
      )
      SELECT a.*, ts_rank(vector.tsv, query.tsq) AS tsr
        FROM articles_with_content_and_tag_strings a, vector, query
      WHERE vector.tsv @@ query.tsq AND vector.id = a.id
      ORDER BY tsr DESC
    SQL
    # 预加载用户头像
    ActiveRecord::Associations::Preloader.new.preload(@articles, [:rich_text_content, user: :avatar_attachment])
  end

  def recent
    @articles = Article.with_tag_strings.with_rich_text_content_and_embeds
                       .includes(user: :avatar_attachment)
                       .order(created_at: :desc).page(params[:page]).per_page(10)
  end

  def following
    @articles = Article.with_tag_strings
                       .with_rich_text_content_and_embeds
                       .includes(user: :avatar_attachment)
                       .where(user_id: current_user.following_ids)
                       .order(created_at: :desc).page(params[:page]).per_page(10)
  end
end
