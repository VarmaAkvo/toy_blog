class AddContentToComment < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :content, :string, null: false
  end
end
