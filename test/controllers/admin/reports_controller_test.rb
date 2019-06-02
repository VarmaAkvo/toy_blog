require 'test_helper'

class Admin::ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report = reports(:one)
  end

  test 'should get index' do
    get admin_reports_path, headers_hash
    assert_response :success
  end

  test 'should get show' do
    get admin_report_path(@report), headers_hash
    assert_response :success
  end

  test 'should agree a report' do
    # 同意一项举报会让其他对这reportable的举报都被标记为processed, 并删除相应的reportable
    assert Report.processed.count == 0
    assert_difference('Article.count', -1) do
      put agree_admin_report_path(@report), headers_hash
    end
    assert Report.processed.count > 1
    assert_redirected_to admin_reports_path
  end

  test 'should disagree a report' do
    # 反对一项举报会将其删除
    assert_difference('Report.count', -1) do
      put disagree_admin_report_path(@report), headers_hash
    end
    assert_redirected_to admin_reports_path
  end

  test 'should destroy has not processed report before a reportable destroy' do
    article = @report.reportable
    @report2 = reports(:three)
    comment = @report2.reportable
    #assert_equal comment.article_id, article.id
    assert_difference('Article.count', -1) do
      put agree_admin_report_path(@report), headers_hash
    end
    assert_not Report.exists?(@report2.id)
  end
end
