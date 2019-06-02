class Punishment < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :expire_time, presence: true

  attr_accessor :punished_name, :extra_time
end
