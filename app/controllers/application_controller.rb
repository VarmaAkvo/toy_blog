class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    if params[:user].present? and   params[:user][:name].present?
      params[:user][:name].downcase!
    end
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
