class Notify::CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles = Article.includes(:user).where(user_id: current_user.id).order(updated_at: :desc)
                         .page(params[:page]).per_page(10)
  end
end
