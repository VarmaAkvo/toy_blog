require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test 'should get new' do
    get new_report_path, params: {report: {reportable_type: 'Article', reportable_id: 1}}
    assert_response :success
  end

  test 'should create report' do
    assert_difference('Report.count') do
      post reports_path, params:{ report: {
        reason: 'reason',
        reportable_type: 'Article', reportable_id: 1,
        }}
    end
    assert_redirected_to root_path
    # 不能重复举报
    assert_no_difference('Report.count') do
      post reports_path, params:{ report: {
        reason: 'reason2',
        reportable_type: 'Article', reportable_id: 1,
        }}
    end
  end
end
