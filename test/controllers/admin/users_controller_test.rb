require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_users_path, headers_hash
    assert_response :success
  end
end