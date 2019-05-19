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
end
