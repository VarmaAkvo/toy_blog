class Search::UsersController < ApplicationController
  def index
    @users_array = User.paginate_by_sql([<<-SQL , params[:query]], page: params[:page], per_page: 9
      with utags as (
      	select string_agg(t.name, ' ') as name, u.id as u_id
      	from tags as t, tagging as tg, users as u
      	where tg.taggable_id = u.id and tg.taggable_type = 'User' and tg.tag_id = t.id
      	group by u_id
      ) , vector as (
      	select (setweight(to_tsvector(u.name), 'A') ||
      			to_tsvector(u.profile) ||
      		    setweight(to_tsvector(utags.name), 'B')) as tsv, utags.u_id
      	from users as u, utags
      	where u.id = utags.u_id
      ), query as (
      	select to_tsquery(?) as tsq
      )
      select u.*, ts_rank(vector.tsv, query.tsq) as tsr
      from users as u, vector, query
      where vector.tsv @@ query.tsq and vector.u_id = u.id
      order by tsr desc
      SQL
    )
    # 预加载关联
    @users = User.includes(:tags, :avatar_attachment).where(id: @users_array.map(&:id))
    @users_hash = @users.map {|u| [u.id, u]}.to_h
    @users_follower_count = Relation.where(followed_id: @users.ids)
                                    .group(:followed_id).count(:follower_id)
  end

  def ranking
    @users = User.includes(:tags, :avatar_attachment).joins(:following).group(:id)
                .order(Arel.sql('COUNT(relations.id) DESC')).page(params[:page]).per_page(9)
    @users_follower_count = Relation.where(followed_id: @users.ids)
                                    .group(:followed_id).count(:follower_id)
  end
end
