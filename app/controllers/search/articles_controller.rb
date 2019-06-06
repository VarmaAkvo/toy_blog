class Search::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: :following
  def index
=begin
    @articles_array = Article.paginate_by_sql([<<-SQL ,params[:query]], page: params[:page], per_page: 10
      with title_and_content as (
      	select a.id as a_id, a.title, atrt.body as content
      	from articles as a, action_text_rich_texts as atrt
      	where a.id = atrt.record_id and atrt.record_type = 'Article'
      ), atags as (
      	select string_agg(t.name, ' ') as name, a.id as a_id from tags as t, tagging as tg, articles as a
      	where tg.taggable_id = a.id and tg.taggable_type = 'Article' and tg.tag_id = t.id
      	group by a_id
      ), vector as (
      	select tac.a_id,
               (setweight(to_tsvector(tac.title), 'A') || to_tsvector(tac.content)
               || setweight(to_tsvector(atags.name), 'B')) as tsv
      	from title_and_content as tac, atags
        where tac.a_id = atags.a_id
      ), query as (
      	select to_tsquery(?) as tsq
      )
      select a.*, ts_rank(vector.tsv, query.tsq) as tsr
      from articles as a, vector, query
      where vector.tsv @@ query.tsq and vector.a_id = a.id
      order by tsr desc
      SQL
    )
    # 预加载关联
    @articles = Article.with_rich_text_content_and_embeds.includes(:tags, user: :avatar_attachment)
                       .where(id: @articles_array.map(&:id))
    @articles_hash = @articles.map { |a| [a.id, a] }.to_h
=end
    @articles =  Article.paginate_by_sql([<<-SQL ,params[:query]], page: params[:page], per_page: 10)
      WITH articles_content AS (
        SELECT a.id, atrt.body as content
          FROM articles a, action_text_rich_texts atrt
        WHERE a.id = atrt.record_id AND atrt.record_type = 'Article'
      ), articles_tag_strings AS (
        SELECT string_agg(t.name, ' ') as tag_strings, a.id
      	FROM articles a
      	  INNER JOIN tagging tg ON tg.taggable_id = a.id and tg.taggable_type = 'Article'
      	  INNER JOIN tags t ON tg.tag_id = t.id
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
      		   setweight(to_tsvector(a.tag_strings), 'B')
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
