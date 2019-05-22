class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.belongs_to :comment, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
