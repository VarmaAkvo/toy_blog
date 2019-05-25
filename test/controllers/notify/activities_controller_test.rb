require 'test_helper'

class Notify::ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    sign_in users(:one)
    get notify_activities_path
    assert_response :success
  end
end
