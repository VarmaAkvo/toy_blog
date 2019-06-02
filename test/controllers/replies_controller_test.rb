require 'test_helper'

class RepliesControllerTest < ActionDispatch::IntegrationTest
  test 'should create reply' do
    @comment = comments(:one)
    sign_in users(:one)
    assert_difference('Reply.count') do
      post comment_replies_path(@comment), params: {reply: {
        content: 'reply'
        }}
    end
    assert_redirected_to user_article_path(users(:one).name, @comment.article_id)
    # 被封禁的用户无法回复
    sign_out users(:one)
    sign_in users(:punished)
    assert_no_difference('Reply.count') do
      post comment_replies_path(@comment), params: {reply: {
        content: 'reply'
        }}
    end
    # 封禁过期解除后可正常发评论
    travel_to 2.days.after do
      assert_difference('Reply.count') do
        post comment_replies_path(@comment), params: {reply: {
          content: 'reply'
          }}
      end
    end
  end

  test 'the user punished by admin can not create any reply' do
    @comment = comments(:one)
    sign_in users(:admin_punished)
    assert_no_difference('Reply.count') do
      post comment_replies_path(@comment), params: {reply: {
        content: 'reply'
        }}
    end
  end

  test "should destroy only user is article's owner" do
    @reply = replies(:one)
    @article = @reply.comment.article
    @user = users(:two)
    @owner = @article.user
    assert_not_equal @user, @owner

    sign_in @user
    assert_no_difference('Reply.count') do
      delete reply_path(@reply)
    end
    assert_redirected_to user_article_path(@owner.name, @article.id)

    sign_out @user
    sign_in @owner

    assert_difference('Reply.count', -1) do
      delete reply_path(@reply)
    end
    assert_redirected_to user_article_path(@owner.name, @article.id)
  end
end
