require 'test_helper'

class Admin::PunishmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @punishment = punishments(:one)
  end

  test 'should get index' do
    get admin_punishments_path, headers_hash
    assert_response :success
  end

  test 'should get new' do
    get new_admin_punishment_path, headers_hash
    assert_response :success
  end

  test 'should create punishment' do
    assert_difference('Punishment.count') do
      post admin_punishments_path, {params: { punishment: {
        punished_name: users(:two).name, expire_time: '1'
        }}}.merge(headers_hash)
    end
    assert_redirected_to admin_punishments_path
  end

  test 'should get edit' do
    get edit_admin_punishment_path(@punishment), headers_hash
    assert_response :success
  end

  test 'should update punishment' do
    one_day_after =  @punishment.expire_time + 1.day
    put admin_punishment_path(@punishment), {params: { punishment: {
      extra_time: '1'
      }}}.merge(headers_hash)
    assert @punishment.reload.expire_time >= one_day_after
  end

  test 'should destroy punishment' do
    assert_difference('Punishment.count', -1) do
      delete admin_punishment_path(@punishment), headers_hash
    end
    assert_redirected_to admin_punishments_path
  end
end
