require 'test_helper'

class CommentControllerTest < ActionDispatch::IntegrationTest
  test 'should create comment' do
    @article = articles(:one)
    @user = @article.user
    sign_in @user
    assert_difference('Comment.count') do
      post article_comments_path(@article), params: {comment: {
        content: 'comment'
        }}
    end
    assert_redirected_to user_article_path(@user.name, @article.id)
    # 被封禁的用户无法发评论
    sign_out @user
    sign_in users(:punished)
    assert_no_difference('Comment.count') do
      post article_comments_path(@article), params: {comment: {
        content: 'comment'
        }}
    end
  end

  test "should destroy only user is article's owner" do
    @user = users(:two)
    @comment = comments(:one)
    @owner = @comment.article.user
    assert_not_equal @user, @owner

    sign_in @user
    assert_no_difference('Comment.count') do
      delete comment_path(@comment)
    end
    assert_redirected_to user_article_path(@owner.name, @comment.article_id)

    sign_out @user
    sign_in @owner

    assert_difference('Comment.count', -1) do
      delete comment_path(@comment)
    end
    assert_redirected_to user_article_path(@owner.name, @comment.article_id)
  end
end
