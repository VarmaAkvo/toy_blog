class Search::UserTagsController < ApplicationController
  def index
    tag = params[:tag]
    # 返回符合条件的用户并按关注数排列
    @users = User.with_follower_count.includes(:avatar_attachment)
                 .where("tag_list LIKE ?", "%#{tag}%")
                 .order(follower_count: :desc).page(params[:page]).per_page(9)
  end
end
