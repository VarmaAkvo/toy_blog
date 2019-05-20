require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @article = articles(:one)
    sign_in @user
  end

  test 'can only get show and index without sign in' do
    sign_out @user
    get user_articles_path(@user.name)
    assert_response :success

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
      title: 'new_artcle', content: 'content', tag_list: ''
      }}
    assert_not_equal 'new_artcle', @other_article.reload.title

    assert_no_difference('Article.count') do
      delete user_article_path(@other.name, @other_article)
    end
  end

  test 'should get index' do
    get user_articles_path(@user.name)
    assert_response :success
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
    # 没有tag的文章
    assert_difference('Article.count') do
      post articles_path, params: { article: {
        title: 'new_artcle', content: 'content', tag_list: ''
        }}
    end
    assert_redirected_to user_article_path(@user.name, Article.last)
    # 有tag的文章，重复tag会被删除
    tags = "tag1 tag2 tag3 tag4 tag4"
    post  articles_path, params: { article: {
      title: 'new_artcle', content: 'content', tag_list: tags
      }}
    assert_equal tags.split.uniq.sort!, Article.last.tags.pluck(:name).sort!
    # 一篇文章最多拥有10个tag
    tags = (1..11).to_a.join(' ')
    post  articles_path, params: { article: {
      title: 'new_artcle', content: 'content', tag_list: tags
      }}
    assert_equal 10, Article.last.tags.count
  end

  test 'should update article' do
    title, content = 'new_artcle', '中文'
    original_tags = @article.tags.pluck(:name).sort
    put user_article_path(@user.name, @article), params: { article: {
      title: title, content: content, tag_list: 'tag1 tag2'
      }}
    @article.reload
    assert_equal title,   @article.title
    assert @article.content.body.to_s.include? content
    assert_equal original_tags, @article.tags.pluck(:name).sort
    assert_redirected_to user_article_path(@user.name, @article)
  end

  test 'should cover original tags when update tags' do
    tags = @article.tags.pluck(:name)
    new_tag = 'new_tag'
    assert_not tags.include? new_tag
    put user_article_path(@user.name, @article), params: { article: {
      title: @article.title, content: @article.content, tag_list: new_tag
      }}
    @article.reload
    assert_equal new_tag, @article.tags.pluck(:name).join
  end

  test 'should destroy article' do
    assert_difference('Article.count', -1) do
      delete user_article_path(@user.name, @article)
    end
    assert_redirected_to user_articles_path(@user.name)
    assert_equal 0, @article.tagging.count
    assert UserArticlesTagsStatistic.find_by(user_id: @article.user_id).nil?
  end
end
