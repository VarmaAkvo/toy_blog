require 'test_helper'

class RelationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @followed = users(:two)
    sign_in @user
  end

  test 'should get index' do
    get following_path
    assert_response :success
  end

  test 'should follow and unfollow a user' do
    assert_not @user.following? @followed

    post user_following_path(@followed)
    assert @user.following? @followed
    assert_redirected_to user_articles_path(@followed.name)

    delete user_following_path(@followed)
    assert_not @user.following? @followed
    assert_redirected_to user_articles_path(@followed.name)
  end
end
