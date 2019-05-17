class CreateTagsAndTaggingAndUserArticlesTagsStatistics < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name,         null: false
      t.datetime :created_at, null: false
    end

    create_table :tagging do |t|
      t.references :tag,      null: false
      t.references :taggable, null: false, polymorphic: true
    end
    # 记录某个用户的所有文章的每个tag出现总次数
    create_table :user_articles_tags_statistics do |t|
      t.references :user, null: false
      t.references :tag,  null: false
      t.integer :total,   null: false
    end

    add_index :tags, :name, unique: true
    add_index :tagging, [:taggable_type, :taggable_id, :tag_id], unique: true
    add_index :user_articles_tags_statistics, [:user_id, :tag_id], unique: true
  end
end
