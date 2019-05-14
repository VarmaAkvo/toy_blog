class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
    add_index :articles, :title
  end
end
