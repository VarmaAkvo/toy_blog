require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @article = articles(:one)
    sign_in @user
  end

  test 'can only get show without sign in' do
    sign_out @user
    get new_article_path
    assert_response :redirect

    get edit_user_article_path(@user.name, @article)
    assert_response :redirect

    get user_article_path(@user.name, @article)
    assert_response :success

    post articles_path
    assert_redirected_to new_user_session_path

    put user_article_path(@user.name, @article)
    assert_redirected_to new_user_session_path

    delete user_article_path(@user.name, @article)
    assert_redirected_to new_user_session_path
  end

  test 'only owner can edit, update, destroy the article' do
    @other_article = articles(:two)
    @other = @other_article.user
    assert_not_equal @other, @user

    get edit_user_article_path(@other.name, @other_article)
    assert_response :redirect

    put user_article_path(@other.name, @other_article), params: {article: {
      title: 'new_artcle', content: 'content'
      }}
    assert_not_equal 'new_artcle', @other_article.reload.title

    assert_no_difference('Article.count') do
      delete user_article_path(@other.name, @other_article)
    end
  end

  test 'should get new' do
    get new_article_path
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_article_path(@user.name, @article)
    assert_response :success
  end

  test 'should get show' do
    get user_article_path(@user.name, @article)
    assert_response :success
  end

  test 'should create article' do
    assert_difference('Article.count') do
      post articles_path, params: { article: {
        title: 'new_artcle', content: 'content'
        }}
    end
    assert_redirected_to user_article_path(@user.name, Article.last)
  end

  test 'should update article' do
    title, content = 'new_artcle', '中文'
    assert_not @article.content.body.to_s.include? content
    put user_article_path(@user.name, @article), params: { article: {
      title: title, content: content
      }}
    @article.reload
    assert_equal title,   @article.title
    assert @article.content.body.to_s.include? content
    assert_redirected_to user_article_path(@user.name, @article)
  end

  test 'should destroy article' do
    assert_difference('Article.count', -1) do
      delete user_article_path(@user.name, @article)
    end
    assert_redirected_to root_url
  end
end
