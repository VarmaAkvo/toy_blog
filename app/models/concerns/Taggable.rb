require 'active_support/concern'

module Taggable
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
  end

  def create_tags(tags)
    valid_tags = pick_valid_tags(tags)
    add_tags(valid_tags)
  end

  def update_tags(tags)
    valid_tags_array = pick_valid_tags(tags)
    new_tags_array, discard_tags_array = get_new_tags_and_discard_tags(valid_tags_array)
    remove_tags(discard_tags_array)
    add_tags(new_tags_array)
  end

  def delete_tags
    discard_tags_array = self.tags.pluck(:id)
    remove_tags(discard_tags_array)
  end

  private
  # 去除重复tag并且只取限制范围内的tag
  # tags 的格式应为 "tag1 tag2 tag3"
  def pick_valid_tags(tags)
    tags.split.uniq.take(self.class.const_get(:MAXIMUM_TAG_TOTAL))
  end
  # 根据处理过了的合法tags取出要删除的原有的tags以及合法tags中新增的tags
  # new_tags_array 为新增tags的name的数组
  # discard_tags_array 为要删除的tags的id的数组
  def get_new_tags_and_discard_tags(valid_tags_array)
    discard_tags_array = self.tags.where.not(name: valid_tags_array).pluck(:id)
    new_tags_array = valid_tags_array - self.tags.pluck(:name)
    return [new_tags_array, discard_tags_array]
  end
  # 删除给予tags对应的tagging，如果某tag不再有对应的tagging则将其一并删除
  def remove_tags(discard_tags_array)
    self.tagging.where(tag_id: discard_tags_array).each {|tagging| tagging.destroy}
    discard_tags_array.each do |tag_id|
      Tag.destroy(tag_id) unless Tagging.exists?(tag_id: tag_id)
    end
    # 如果self是article，则更新 UserArticleTagsStatistic 的信息
    if self.is_a? Article
      UserArticlesTagsStatistic.where(user_id: self.user_id, tag_id: discard_tags_array).each do |uats|
        uats.decrement!(:total)
        uats.destroy if uats.total == 0
      end
    end
  end
  # 给目标添加新tags, 如果是数据库中不存在的tag则创建它
  def add_tags(new_tags_array)
    new_tags_array.each do |tag_name|
      Tag.create(name: tag_name) unless Tag.exists?(name: tag_name)
    end
    new_tag_ids = Tag.where(name: new_tags_array).ids
    params = new_tag_ids.map { |id| {tag_id: id}  }
    self.tagging.create(params)
    # 如果self是article，则更新 UserArticleTagsStatistic 的信息
    if self.is_a? Article
      new_tag_ids.each do |tag_id|
        if UserArticlesTagsStatistic.exists?(user_id: self.user_id, tag_id: tag_id)
          UserArticlesTagsStatistic.find_by(user_id: self.user_id, tag_id: tag_id).increment!(:total)
        else
          UserArticlesTagsStatistic.create(user_id: self.user_id, tag_id: tag_id, total: 1)
        end
      end
    end
  end
end
