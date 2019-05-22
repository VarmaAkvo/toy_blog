class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  has_many :replies

  validates :content, presence: true
end
