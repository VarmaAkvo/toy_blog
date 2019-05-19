require 'test_helper'

class Settings::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get edit" do
    get edit_settings_user_url
    assert_response :success
    sign_out @user
    get edit_settings_user_url
    assert_response :redirect
  end

  test "should update user setting" do
    name = 'new_name'
    profile = 'It is a profile'
    assert_not_equal profile, @user.profile
    put settings_user_url, params: {user:{
      profile: profile, name: name
      }}
    assert_redirected_to edit_settings_user_url
    assert_equal profile, @user.reload.profile
    assert_equal name, @user.name
  end
end
