require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  setup do
    @article = articles(:one)
  end

  test 'should be true' do
    assert @article.valid?
  end

  test 'title should be present' do
    @article.title = ''
    assert_not @article.valid?
  end

  test 'title should not longer than 150' do
    @article.title = 'a' * 151
    assert_not @article.valid?
  end

  test 'content should be present' do
    @article.content = ''
    assert_not @article.valid?
  end

  test 'content should not longer than 5000' do
   @article.content = 'a' * 5001
   assert_not @article.valid?
  end
end
