require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report = reports(:one)
  end

  test 'should be true' do
    assert  @report.valid?
  end

  test 'reason should be present' do
    @report.reason = ''
    assert_not @report.valid?
  end
end
