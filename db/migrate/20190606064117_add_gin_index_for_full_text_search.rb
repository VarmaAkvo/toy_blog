class AddGinIndexForFullTextSearch < ActiveRecord::Migration[6.0]
  def up
    execute(<<-SQL)
      CREATE INDEX gin_index_articles_on_title ON articles USING GIN (to_tsvector('english', title));
      CREATE INDEX gin_index_action_text_rich_texts_on_body ON action_text_rich_texts USING GIN (to_tsvector('english', body));
      CREATE INDEX gin_index_tags_on_name ON tags USING GIN (to_tsvector('english', name));
      CREATE INDEX gin_index_users_on_name ON users USING GIN (to_tsvector('english', name));
      CREATE INDEX gin_index_users_on_profile ON users USING GIN (to_tsvector('english', profile));
    SQL
  end

  def down
    execute(<<-SQL)
      DROP INDEX gin_index_articles_on_title;
      DROP INDEX gin_index_action_text_rich_texts_on_body;
      DROP INDEX gin_index_tags_on_name;
      DROP INDEX gin_index_users_on_name;
      DROP INDEX gin_index_users_on_profile;
    SQL
  end
end
