class AddUpdatedAtToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :updated_at, :datetime
  end
end
