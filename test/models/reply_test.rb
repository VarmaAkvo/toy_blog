require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  test 'content should be present' do
    Comment.create(user_id: users(:one).id, article_id: articles(:one).id, content: 'comment', floor: 1)
    @reply = Reply.create(comment_id: Comment.first.id, user_id: 1, content: 'reply')
    assert @reply.valid?
    @reply.content = ''
    assert_not @reply.valid?
  end
end
