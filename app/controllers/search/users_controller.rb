class Search::UsersController < ApplicationController
  def index
=begin
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
=end
  @users = User.paginate_by_sql([<<-SQL , params[:query]], page: params[:page], per_page: 9)
      WITH users_tag_strings AS (
        SELECT string_agg(t.name, ' ') AS tag_strings, u.id
      	FROM users u
      	  INNER JOIN tagging tg ON tg.taggable_id = u.id
      	         AND tg.taggable_type = 'User'
      	  INNER JOIN tags t ON tg.tag_id = t.id
        GROUP BY u.id
      ), users_follower_count AS (
        SELECT COUNT(r.id) AS follower_count, u.id
      	FROM users u
      	  INNER JOIN relations r ON r.followed_id = u.id
      	GROUP BY u.id
      ), users_with_tag_strings_and_follower_count AS (
        SELECT u.*, uts.tag_strings, ufc.follower_count
      	FROM users u
      	  INNER JOIN users_tag_strings uts ON uts.id = u.id
      	  INNER JOIN users_follower_count ufc ON ufc.id = u.id
      ), vector AS (
        SELECT  u.id,
      	      (setweight(to_tsvector(u.name), 'A') ||
      		    to_tsvector(u.profile) ||
      		    setweight(to_tsvector(u.tag_strings), 'B')
      		  ) as tsv
        FROM users_with_tag_strings_and_follower_count u
      ), query AS (
        SELECT websearch_to_tsquery(?) AS tsq
      )
      SELECT u.*, ts_rank(vector.tsv, query.tsq) AS tsr
      FROM users_with_tag_strings_and_follower_count u, vector, query
      WHERE vector.tsv @@ query.tsq AND vector.id = u.id
      ORDER BY tsr DESC
    SQL
  # 预加载用户头像
  ActiveRecord::Associations::Preloader.new.preload(@users, :avatar_attachment)
  end

  def ranking
=begin
    @users = User.includes(:tags, :avatar_attachment).joins(:following).group(:id)
                .order(Arel.sql('COUNT(relations.id) DESC')).page(params[:page]).per_page(9)
    @users_follower_count = Relation.where(followed_id: @users.ids)
                                    .group(:followed_id).count(:follower_id)
=end
    @users = User.with_tag_strings_and_follower_count.includes(:avatar_attachment)
                 .order(follower_count: :desc).page(params[:page]).per_page(9)
  end
end
