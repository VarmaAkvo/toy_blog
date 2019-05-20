require 'test_helper'

class UserArticlesTagsStatisticTest < ActiveSupport::TestCase
  setup do
    @uats = user_articles_tags_statistics(:two)
  end

  test 'should be true' do
    assert @uats.valid?
  end

  test '[user_id, tag_id] should be uniq' do
    assert_not  @uats.dup.valid?
  end
end
