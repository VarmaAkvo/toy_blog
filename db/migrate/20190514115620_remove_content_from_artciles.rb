class RemoveContentFromArtciles < ActiveRecord::Migration[6.0]
  def change
    # 使用action_text后article不需要保有content
    remove_column :articles, :content, :text, null: false
  end
end
