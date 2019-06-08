class HomeController < ApplicationController
  def index
    # 如果用户已登录，则选出所关注的博客中最新的9条
    if user_signed_in?
      @recent_following_articles = Article.includes(user: :avatar_attachment)
                                          .where(user_id: current_user.following_ids)
                                          .order(created_at: :desc).limit(9)
    end
    # 选出最受欢迎的9个用户的{id: follower_count}
    @ranking_users = User.with_attached_avatar.with_follower_count
                         .order(follower_count: :desc).limit(9)
    # 最新文章
    @recent_articles = Article.includes(user: :avatar_attachment)
                              .order(created_at: :desc).limit(9)
  end
end
