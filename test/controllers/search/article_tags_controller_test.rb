require 'test_helper'

class Search::ArticleTagsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get search_article_tags_path('tag1')
    assert_response :success
  end
end
