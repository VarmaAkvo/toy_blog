class Report < ApplicationRecord
  belongs_to :reporter, class_name: 'User', foreign_key: :reporter_id
  belongs_to :reported, class_name: 'User', foreign_key: :reporter_id
  belongs_to :reportable, polymorphic: true

  validates :reason, presence: true

  scope :processed,         -> { where(processed: true) }
  scope :has_not_processed, -> { where(processed: false) }
end
