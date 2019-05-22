require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'content should be present' do
    @comment = Comment.create(user_id: users(:one).id, article_id: articles(:one).id, content: 'comment', floor: 1)
    assert @comment.valid?
    @comment.content = ''
    assert_not @comment.valid?
  end
end
