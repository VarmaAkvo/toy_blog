require 'active_support/concern'

module Taggable
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
  end

  def save_with_tags(tags)
    self.class.transaction do
      if self.save and !tags.empty?
        # 去除重复tag
        valid_tags = tags.split.uniq
        add_tags(valid_tags)
      end
      self.valid?
    end
  end

  def update_with_tags(tags, params)
    self.class.transaction do
      unless tags.empty?
        # 去除重复tag
        valid_tags = tags.split.uniq
        remove_tags
        add_tags(valid_tags)
      end
      self.update(params)
    end
  end

  private

  def add_tags(valid_tags)
    valid_tags.each do |tag|
      # 如果是数据库中不存在的tag 则创建它
      Tag.create(name: tag) unless Tag.exists?(name: tag)
    end
    # 创建tagging 关联
    tag_ids = Tag.where(name: valid_tags).pluck(:id)
    tag_ids.each do |tag_id|
      self.tagging.create(tag_id: tag_id)
    end
  end

  def remove_tags
    # 删除所有tagging
    self.tagging.each do |tagging|
      tagging.destroy
      # 如果一个tag不再被tagging就删除它
      if Tagging.exists?( tag_id: tagging.tag_id)
        Tag.destroy(tagging.tag_id)
      end
    end
  end
end
