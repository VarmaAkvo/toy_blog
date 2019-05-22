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
  end
end
