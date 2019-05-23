class CreateRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :relations do |t|
      t.bigint :follower_id, null: false
      t.bigint :followed_id, null: false
    end

    add_index :relations, :followed_id
    add_index :relations, :follower_id
    add_index :relations, [:followed_id, :follower_id], unique: true
  end
end
