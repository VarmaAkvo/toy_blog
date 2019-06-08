require_relative '20190606064117_add_gin_index_for_full_text_search'

class AddFullTextSearchFieldToArticles < ActiveRecord::Migration[6.0]
  def change
    # 单独的不起作用
    revert AddGinIndexForFullTextSearch
    # 将article全文搜索需要的位于其他表的信息冗余到articles表中
    # 将content的tag去掉以免干扰搜索
    add_column :articles, :striped_tags_content, :text
    add_column :articles, :tag_list, :string
    # 更新原有记录
    Article.all.each do |article|
      article.striped_tags_content = ActionController::Base.helpers.strip_tags(article.content.to_s).strip
      article.tag_list = article.tags.pluck(:name).join(' ')
      article.save
    end
    # GIN index
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE INDEX gin_index_on_articles ON articles
            USING GIN (to_tsvector('english', title || ' ' || COALESCE(striped_tags_content, ' ') || ' ' || COALESCE(tag_list, ' ')));
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP INDEX gin_index_on_articles;
        SQL
      end
    end
  end
end
