require 'test_helper'

class PunishmentTest < ActiveSupport::TestCase
  setup do
    @punishment = punishments(:one)
  end

  test 'should be true' do
    assert @punishment.valid?
  end

  test 'user_id should be uniq' do
    assert_not @punishment.dup.valid?
  end

  test 'expire_time should be present' do
    @punishment.expire_time = nil
    assert_not @punishment.valid?
  end
end
