class Search::UsersController < ApplicationController
  def index
    @users = User.paginate_by_sql([<<-SQL , query: params[:query]], page: params[:page], per_page: 9)
      SELECT u.*, COUNT(r.id) AS follower_count
      FROM users u
        LEFT OUTER JOIN relations r ON r.followed_id = u.id
      WHERE to_tsvector('english', name || ' ' || COALESCE(profile, ' ') || ' ' || COALESCE(tag_list, ' '))
              @@ websearch_to_tsquery(:query)
      GROUP BY u.id
      ORDER BY ts_rank((
        setweight(to_tsvector(name), 'A') ||
        to_tsvector(COALESCE(profile, ' ')) ||
        setweight(to_tsvector(COALESCE(tag_list, ' ')), 'B')
        ), websearch_to_tsquery(:query)) DESC
    SQL
    # 预加载用户头像
    ActiveRecord::Associations::Preloader.new.preload(@users, :avatar_attachment)
  end

  def ranking
    @users = User.with_follower_count.includes(:avatar_attachment)
                 .order(follower_count: :desc).page(params[:page]).per_page(9)
  end
end
