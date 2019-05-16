class Article < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  MAXIMUM_TITLE_LENGTH = 150
  MAXIMUM_CONTENT_LENGTH = 5001
  validates :title,   presence: true, length: {maximum: MAXIMUM_TITLE_LENGTH }
  validates :content, presence: true, length: {maximum: MAXIMUM_CONTENT_LENGTH}
end
