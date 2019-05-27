class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_new_notify, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    if params[:user].present? and   params[:user][:name].present?
      params[:user][:name].downcase!
    end
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def check_new_notify
    @has_new_notify = false
    @last_visit_time = NotifyVisitTime.find_or_create_by(user_id: current_user.id)
    current_time = Time.current
    if Article.exists?(user_id: current_user.following_ids, created_at: @last_visit_time.updated_at..current_time)
      @has_new_notify = true and return
    end
    if Comment.exists?(article_id: current_user.article_ids, created_at: @last_visit_time.updated_at..current_time)
      @has_new_notify = true and return
    end
    if Reply.exists?(comment_id: current_user.comment_ids, created_at: @last_visit_time.updated_at..current_time)
      @has_new_notify = true
    end
  end
end
