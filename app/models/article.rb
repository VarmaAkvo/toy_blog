class Article < ApplicationRecord
  include Taggable

  belongs_to :user
  has_rich_text :content
  has_many :tagging, class_name: 'Tagging', as: :taggable
  has_many :tags, through: :tagging

  MAXIMUM_TITLE_LENGTH = 150
  MAXIMUM_CONTENT_LENGTH = 5001
  MAXIMUM_TAG_TOTAL = 10
  validates :title,   presence: true, length: {maximum: MAXIMUM_TITLE_LENGTH }
  validates :content, presence: true, length: {maximum: MAXIMUM_CONTENT_LENGTH}

  attr_accessor :tag_list
end
