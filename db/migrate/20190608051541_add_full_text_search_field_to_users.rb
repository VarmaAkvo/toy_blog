class AddFullTextSearchFieldToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tag_list, :string
    # 更新原有记录
    User.all.each do |user|
      user.tag_list = user.tags.pluck(:name).join(' ')
      user.save
    end
    # GIN index
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE INDEX gin_index_on_users ON users
            USING GIN (to_tsvector('english', name || ' ' || COALESCE(profile, ' ') || ' ' || COALESCE(tag_list, ' ')));
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP INDEX gin_index_on_users;
        SQL
      end
    end
  end
end
