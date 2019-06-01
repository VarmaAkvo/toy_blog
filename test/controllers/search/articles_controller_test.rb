require 'test_helper'

class Search::ArticlesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get search_articles_path, params: {query: 'tag1'}
    assert_response :success
  end
end
