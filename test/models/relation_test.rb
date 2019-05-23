require 'test_helper'

class RelationTest < ActiveSupport::TestCase
  test '[followed_id, follower_id] should be uniq' do
    @relation = Relation.create(followed_id: 1, follower_id: 2)
    assert @relation.valid?
    assert_not @relation.dup.valid?
  end
end
