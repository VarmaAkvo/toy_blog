require 'test_helper'

class TagTest < ActiveSupport::TestCase
  setup do
    @tag = tags(:one)
  end

  test 'should be true' do
    assert @tag.valid?
  end

  test 'name should be present' do
    @tag.name = ''
    assert_not @tag.valid?
  end

  test 'tag should be uniq' do
    same_tag = Tag.new(name: @tag.name)
    assert_not same_tag.valid?
  end
end
