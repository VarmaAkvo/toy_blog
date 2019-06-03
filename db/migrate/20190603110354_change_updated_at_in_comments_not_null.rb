class ChangeUpdatedAtInCommentsNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:comments, :updated_at, false)
  end
end
