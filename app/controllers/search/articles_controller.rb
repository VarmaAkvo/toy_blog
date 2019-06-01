class Search::ArticlesController < ApplicationController
  def index
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
  end
end
