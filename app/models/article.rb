class Article < ApplicationRecord
  include Taggable

  belongs_to :user
  has_rich_text :content
  has_many :tagging, class_name: 'Tagging', as: :taggable, dependent: :destroy
  has_many :tags, through: :tagging
  has_many :comments, dependent: :destroy
  has_many :replies, through: :comments

  has_many :reports, as: :reportable

  MAXIMUM_TITLE_LENGTH = 150
  MAXIMUM_CONTENT_LENGTH = 5001
  MAXIMUM_TAG_TOTAL = 10
  validates :title,   presence: true, length: {maximum: MAXIMUM_TITLE_LENGTH }
  validates :content, presence: true, length: {maximum: MAXIMUM_CONTENT_LENGTH}

  scope :tag_strings, -> { joins(:tags)
                           .select("articles.*, string_agg(tags.name, ' ') AS tag_strings")
                           .group(:id)}
  scope :with_tag_strings, -> {
    select('articles.*, t.tag_strings')
   .joins("LEFT OUTER JOIN (#{tag_strings.to_sql}) AS t ON t.id = articles.id")
  }

  before_destroy do
    #将属于它的未处理举报一并删除
    self.reports.has_not_processed.destroy_all
  end
  # 用于单一的article,如show页面等情况
  def get_tag_strings
    tags.pluck(:name).join(' ')
  end

  attr_accessor :tag_list
end
