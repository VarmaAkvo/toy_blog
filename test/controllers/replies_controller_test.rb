require 'test_helper'

class RepliesControllerTest < ActionDispatch::IntegrationTest
  test 'should create reply' do
    @comment = Comment.create(user_id: users(:one).id, article_id: articles(:one).id, content: 'comment', floor: 1)
    sign_in users(:one)
    assert_difference('Reply.count') do
      post comment_replies_path(@comment), params: {reply: {
        content: 'reply'
        }}
    end
    assert_redirected_to user_article_path(users(:one).name, @comment.article_id)
  end
end
