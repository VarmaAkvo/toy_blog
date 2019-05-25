require 'test_helper'

class Notify::CommentsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    sign_in users(:one)
    get notify_comments_path
    assert_response :success
  end
end
