require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  setup do
    @article = articles(:one)
  end

  test 'should be true' do
    assert @article.valid?
  end

  test 'title should be present' do
    @article.title = ''
    assert_not @article.valid?
  end

  test 'title should not longer than 150' do
    @article.title = 'a' * 151
    assert_not @article.valid?
  end

  test 'content should be present' do
    @article.content = ''
    assert_not @article.valid?
  end

  test 'content should not longer than 5000' do
   @article.content = 'a' * 5001
   assert_not @article.valid?
  end

  test 'create_tags should work' do
    @user = @article.user
    tag_list = 't1 tag2'
    tag2_id = Tag.find_by(name: 'tag2').id
    assert Tag.find_by(name: 't1').nil?
    assert_equal 1, UserArticlesTagsStatistic.find_by(user_id: @user.id, tag_id: tag2_id).total

    @user.articles.create(title: @article.title, content: @article.content, tag_list: tag_list)
    Article.last.create_tags(tag_list)

    t1_id = Tag.find_by(name: 't1').id
    assert_not t1_id.nil?
    assert_not Tagging.find_by(taggable_type: 'Article', tag_id: t1_id).nil?
    assert_equal 1, UserArticlesTagsStatistic.find_by(user_id: @user.id, tag_id: t1_id).total
    assert_equal 2, UserArticlesTagsStatistic.find_by(user_id: @user.id, tag_id: tag2_id).total
  end

  test 'update_tags should work' do
    @user = @article.user
    tag_list = 't1 tag2'
    tag1_id = Tag.find_by(name: 'tag1').id
    tag2_id = Tag.find_by(name: 'tag2').id
    assert Tag.find_by(name: 't1').nil?
    assert_equal 1, UserArticlesTagsStatistic.find_by(user_id: @user.id, tag_id: tag2_id).total
    assert_equal 1, UserArticlesTagsStatistic.find_by(user_id: @user.id, tag_id: tag1_id).total

    @article.update_tags(tag_list)

    t1_id = Tag.find_by(name: 't1').id
    assert_not t1_id.nil?
    assert_not Tagging.find_by(tag_id: t1_id).nil?
    assert @article.tagging.find_by(tag_id: tag1_id).nil?
    assert_equal 1, UserArticlesTagsStatistic.find_by(user_id: @user.id, tag_id: t1_id).total
    assert_equal 1, UserArticlesTagsStatistic.find_by(user_id: @user.id, tag_id: tag2_id).total
    assert UserArticlesTagsStatistic.find_by(user_id: @user.id, tag_id: tag1_id).nil?
  end

  test 'delete_tags should work' do
    assert_equal %w[tag1 tag2], @article.tags.pluck(:name)
    tag1_id, tag2_id = @article.tags.pluck(:id)
    @article.delete_tags
    assert @article.tagging.find_by(tag_id: tag1_id).nil?
    assert @article.tagging.find_by(tag_id: tag2_id).nil?
    assert UserArticlesTagsStatistic.find_by(user_id: @article.user_id).nil?
  end
end
