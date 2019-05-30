class BlogPunishment < ApplicationRecord
  belongs_to :punisher, class_name: 'User'
  belongs_to :punished, class_name: 'User'

  validates :punisher_id, uniqueness: {scope: :punished_id}
  validates :expire_time, presence: true

  attr_accessor :punished_name, :extra_time
end
