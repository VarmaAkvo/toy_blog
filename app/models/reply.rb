class Reply < ApplicationRecord
  belongs_to :comment, touch: true
  belongs_to :user
  has_many :reports, as: :reportable

  before_destroy do
    #将属于它的未处理举报一并删除
    self.reports.has_not_processed.destroy_all
  end

  validates :content, presence: true
end
