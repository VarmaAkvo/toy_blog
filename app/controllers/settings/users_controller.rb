class Settings::UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    user_params = user_setting_params.reject {|k, v| k.to_sym == :tag_list}
    @user = current_user
    unless user_setting_params[:tag_list].split.sort ==  @user.tags.pluck(:name).sort
      @user.update_tags(user_setting_params[:tag_list])
      @user.tag_list = @user.tags.pluck(:name).join(' ')
    end
    if @user.update(user_params)
      flash[:notice] = '用户资料更新成功。'
      redirect_to edit_settings_user_path
    else
      render 'edit'
    end
  end

  private

  def user_setting_params
    params.require(:user).permit(:profile, :name, :tag_list, :avatar)
  end
end
