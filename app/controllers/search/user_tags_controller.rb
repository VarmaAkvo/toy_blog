class Search::UserTagsController < ApplicationController
  def index
    tag = params[:tag]
    # 返回符合条件的用户并按关注数排列
    @users = User.includes(:avatar_attachment).joins(:tags, :passive_relations).where(tags: {name: tag})
                      .group(:id).order(Arel.sql('COUNT(relations.id) DESC'))
                      .page(params[:page]).per_page(9)
    @users_follower_count = Relation.where(followed_id: @users.ids)
                                    .group(:followed_id).count(:follower_id)
  end
end
