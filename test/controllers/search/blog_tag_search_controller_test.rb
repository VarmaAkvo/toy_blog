require 'test_helper'

class Search::BlogTagSearchControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get blog_tag_search_path(users(:one).name, 'tag1')
    assert_response :success
  end
end
