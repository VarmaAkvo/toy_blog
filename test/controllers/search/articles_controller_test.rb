require 'test_helper'

class Search::ArticlesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get search_articles_path, params: {query: 'tag1'}
    assert_response :success
  end

  test 'should get recent' do
    get search_recent_articles_path
    assert_response :success
  end

  test 'should get following' do
    sign_in users(:one)
    get search_following_articles_path
    assert_response :success
  end
end
