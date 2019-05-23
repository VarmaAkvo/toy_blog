require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test 'should be valid' do
    assert @user.valid?
    assert @user.valid_password?('123456')
  end

  test 'name should be present' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'name should be uniq and not case sensitive' do
    @user.name = users(:two).name
    assert_not @user.valid?
    @user.name.upcase!
    assert_not @user.valid?
  end

  test 'profile should not longer than 100' do
    @user.profile = 'a'*101
    assert_not @user.valid?
  end

  test 'update_tags should work' do
    tag_list = 't1 tag2'
    tag1_id = Tag.find_by(name: 'tag1').id
    tag2_id = Tag.find_by(name: 'tag2').id
    assert Tag.find_by(name: 't1').nil?

    @user.update_tags(tag_list)

    t1_id = Tag.find_by(name: 't1').id
    assert_not t1_id.nil?
    assert_not @user.tagging.find_by(tag_id: t1_id).nil?
    assert @user.tagging.find_by(tag_id: tag1_id).nil?
  end

  test 'delete_tags should work' do
    assert_equal %w[tag1 tag2], @user.tags.pluck(:name)
    tag1_id, tag2_id = @user.tags.pluck(:id)
    @user.delete_tags
    assert @user.tagging.find_by(tag_id: tag1_id).nil?
    assert @user.tagging.find_by(tag_id: tag2_id).nil?
  end

  test 'after_destroy should work' do
    @user.destroy
    assert_equal 0, @user.tagging.count
  end

  test 'should follow and then unfollow a user' do
    @other = users(:two)
    assert_not @user.following? @other
    @user.follow @other
    assert @user.following? @other
    @user.unfollow @other
    assert_not @user.following? @other
  end
end
