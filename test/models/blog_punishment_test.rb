require 'test_helper'

class BlogPunishmentTest < ActiveSupport::TestCase
  setup do
    @blog_punishment = blog_punishments(:one)
  end

  test 'should be true' do
    assert @blog_punishment.valid?  
  end

  test '[punished_id, punisher_id] should be uniq' do
    assert_not @blog_punishment.dup.valid?
  end

  test 'expire_time should be present' do
    @blog_punishment.expire_time = nil
    assert_not @blog_punishment.valid?
  end
end
