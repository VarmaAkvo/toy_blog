class AddFloorToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :floor, :integer, null:false
  end
end
