require 'test_helper'

class Notify::RepliesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    sign_in users(:one)
    get notify_replies_path
    assert_response :success
  end
end
