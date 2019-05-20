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
    tag_list = 't1 tag2'
    tag1_id = Tag.find_by(name: 'tag1').id
    assert_not_equal profile, @user.profile
    put settings_user_url, params: {user:{
      profile: profile, name: name, tag_list: tag_list
      }}
    assert_redirected_to edit_settings_user_url
    assert_equal profile, @user.reload.profile
    assert_equal name, @user.name
    # 更新tag
    t1_id = Tag.find_by(name: 't1').id
    assert_not t1_id.nil?
    assert_not @user.tagging.find_by(tag_id: t1_id).nil?
    assert @user.tagging.find_by(tag_id: tag1_id).nil?
  end
end
