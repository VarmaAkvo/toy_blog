require 'test_helper'

class BlogPunishmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @punished = users(:punished)
    @blog_punishment = blog_punishments(:one)
  end

  test 'should get index' do
    get blog_punishments_path
    assert_response :success
  end

  test 'should get new' do
    get new_blog_punishment_path
    assert_response :success
  end

  test 'should create blog_punishment' do
    assert_difference('BlogPunishment.count') do
      post blog_punishments_path, params: { blog_punishment: {
        punished_name: users(:two).name, expire_time: '1'
        }}
    end
    assert_redirected_to blog_punishments_path
  end

  test 'should get edit' do
    get edit_blog_punishment_path(@blog_punishment)
    assert_response :success
  end

  test 'should update blog_punishment' do
    one_day_after =  @blog_punishment.expire_time + 1.day
    put blog_punishment_path(@blog_punishment), params: { blog_punishment: {
      extra_time: '1'
      }}
    assert @blog_punishment.reload.expire_time >= one_day_after
  end

  test 'should destroy blog_punishment' do
    assert_difference('BlogPunishment.count', -1) do
      delete blog_punishment_path(@blog_punishment)
    end
    assert_redirected_to blog_punishments_path
  end
end
