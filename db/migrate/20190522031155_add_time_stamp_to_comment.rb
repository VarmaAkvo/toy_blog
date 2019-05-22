class AddTimeStampToComment < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :created_at, :datetime, precision: 6, null: false
  end
end
