require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  setup do
    @tagging = tagging(:one)
  end

  test 'should be true' do
    assert @tagging.valid?
  end

  test 'tagging should be uniq' do
    assert_not @tagging.dup.valid?
  end
end
