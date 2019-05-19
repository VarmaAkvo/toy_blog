class Settings::UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
    @user.tag_list = @user.tags.pluck(:name).join(' ')
  end

  def update
    result = false
    profile_params = { profile: user_setting_params[:profile] }
    @user = current_user

    if user_setting_params[:avatar].present?

    end
    if user_setting_params[:tag_list].present?
      result = !!@user.update_with_tags(user_setting_params[:tag_list], profile_params)
    end
    # 如果没更新tag就单独更新profile
    if !result
      result = !!@user.update(profile_params)
    end
    # 不考虑更新头像失败的情况
    if result
      flash[:notice] = '用户资料更新成功。'
      redirect_to edit_settings_user_path
    else
      render 'edit'
    end
  end

  private

  def user_setting_params
    params.require(:user).permit(:profile, :tag_list, :avatar)
  end
end
