require 'test_helper'

class Search::UserTagsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get search_user_tags_path('tag1')
    assert_response :success
  end
end
