class CreateBlogPunishments < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_punishments do |t|
      t.bigint :punisher_id, null: false
      t.bigint :punished_id, null: false
      t.datetime :expire_time, null: false
    end

    add_index :blog_punishments, :punisher_id
    add_index :blog_punishments, :punished_id
    add_index :blog_punishments, [:punisher_id, :punished_id], unique: true
  end
end
