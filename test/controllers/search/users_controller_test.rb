require 'test_helper'

class Search::UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get search_users_path, params: {query: 'tag1'}
    assert_response :success
  end

  test 'should get ranking' do
    get search_ranking_users_path
    assert_response :success
  end
end
