class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_new_notify, if: :user_signed_in?, only: [:index, :show, :edit]

  protected

  def configure_permitted_parameters
    if params[:user].present? and   params[:user][:name].present?
      params[:user][:name].downcase!
    end
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def check_new_notify
    @has_new_notify = false
    @current_time = Time.now

    @activity_last_visit = ActivityNotifyVisit.find_or_create_by(user_id: current_user.id)
    if Article.exists?(user_id: current_user.following_ids, created_at: @activity_last_visit.updated_at..@current_time)
      @has_new_notify = true and return
    end

    @comment_last_visit = CommentNotifyVisit.find_or_create_by(user_id: current_user.id)
    if Comment.exists?(article_id: current_user.article_ids, created_at: @comment_last_visit.updated_at..@current_time)
      @has_new_notify = true and return
    end

    @reply_last_visit = ReplyNotifyVisit.find_or_create_by(user_id: current_user.id)
    if Reply.exists?(comment_id: current_user.comment_ids, created_at: @reply_last_visit.updated_at..@current_time)
      @has_new_notify = true
    end
  end

  def is_punished_by_admin?
    punishment = Punishment.find_by(user_id: current_user.id)
    return false if punishment.nil?
    if punishment.expire_time > Time.current
      flash[:alert] = "你在#{punishment.expire_time.strftime('%Y年%m月%d日 %H:%M')}之前无法进行发文章、评论和回复。"
      redirect_to root_path
      return true
    else
      punishment.destroy
      return false
    end
  end
end
