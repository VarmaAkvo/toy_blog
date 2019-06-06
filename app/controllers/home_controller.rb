class HomeController < ApplicationController
  def index
    # 如果用户已登录，则选出所关注的博客中最新的9条
    if user_signed_in?
=begin
      @recent_following_articles = Article.includes(:tags, user: :avatar_attachment)
                                          .where(user_id: current_user.following_ids)
                                          .order(created_at: :desc).limit(9)
=end
      # 不load的话渲染视图时对@recent_following_articles会出错
      @recent_following_articles = Article.with_tag_strings.includes(user: :avatar_attachment)
                                          .where(user_id: current_user.following_ids)
                                          .order(created_at: :desc).limit(9)
    end
    # 选出最受欢迎的9个用户的{id: follower_count}
=begin
    @ranking_users_hash = Relation.group(:followed_id).order(count_follower_id: :desc)
                                .limit(9).count(:follower_id)
    @ranking_users = User.includes(:tags, :avatar_attachment).find(@ranking_users_hash.keys)
=end
=begin
    @ranking_users = User.includes(:tags, :avatar_attachment).joins(:followed)
                         .select('users.*, COUNT(relations) AS followed_count')
                         .group(:id).order('followed_count DESC').limit(9)
=end
=begin
    @ranking_users = User.find_by_sql(<<-SQL)
      WITH users_with_tag_list AS (
        SELECT u.*, string_agg(t.name, ' ') AS tag_strings
          FROM users u
            INNER JOIN tagging tg ON tg.taggable_id = u.id AND tg.taggable_type = 'User'
            INNER JOIN tags t ON t.id = tg.tag_id
        GROUP BY u.id
      )
      SELECT DISTINCT u.*, COUNT(f.id) OVER (PARTITION BY u.id) AS followed_count
        FROM users_with_tag_list u
          INNER JOIN relations f ON f.followed_id = u.id
        ORDER BY followed_count DESC
        LIMIT 9;
    SQL
=end
    @ranking_users = User.with_attached_avatar.select('users.*, t.tag_strings, f.follower_count')
                         .joins("INNER JOIN (#{User.follower_count.to_sql}) AS f ON f.id = users.id
                                 INNER JOIN (#{User.tag_strings.to_sql}) AS t ON t.id = users.id")
                         .order(follower_count: :desc).limit(9)
    # 预加载用户头像
    #ActiveRecord::Associations::Preloader.new.preload(@ranking_users, :avatar_attachment)
    # 最新文章
    # @recent_articles = Article.includes(:tags, user: :avatar_attachment).order(created_at: :desc).limit(9)
    @recent_articles = Article.includes(user: :avatar_attachment).joins(:tags)
                              .select("articles.*, string_agg(tags.name, ' ') AS tag_strings")
                              .group(:id).order(created_at: :desc).limit(9)
  end
end
