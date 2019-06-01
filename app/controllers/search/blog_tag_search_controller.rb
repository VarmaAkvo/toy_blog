class Search::BlogTagSearchController < ApplicationController
  def index
    @owner = User.find_by(name: params[:name])
    if @owner.nil?
      flash[:alert] = '该用户不存在'
      redirect_to root_path and return
    end
    tag = params[:tag]
    @articles = @owner.articles.joins(:tags).where(tags: {name: tag})
                      .order(created_at: :desc).page(params[:page]).per_page(10)
    @uats = UserArticlesTagsStatistic.includes(:tag).where(user_id: @owner.id)
  end
end
