class User < ApplicationRecord
  include Taggable

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy

  has_many :tagging, class_name: 'Tagging', as: :taggable, dependent: :destroy
  has_many :tags, through: :tagging
  has_one  :user_articles_tags_statistic, dependent: :destroy

  has_one  :activity_notify_visit, dependent: :destroy
  has_one  :comment_notify_visit, dependent: :destroy
  has_one  :reply_notify_visit, dependent: :destroy

  has_many :active_relations, class_name: 'Relation', foreign_key: :follower_id, dependent: :destroy
  has_many :following, class_name: 'User', through: :active_relations, source: :followed
  has_many :passive_relations, class_name: 'Relation', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, class_name: 'User', through: :passive_relations

  has_many :blog_punishments, foreign_key: :punisher_id, dependent: :destroy
  has_many :punishing, class_name: 'User', through: :blog_punishments, source: :punished

  has_one :punishment, dependent: :destroy

  has_many :reported_records, -> { where(processed: true) }, class_name: 'Report', foreign_key: :reported_id

  has_one_attached :avatar
  after_destroy :delete_tags

  MAXIMUM_TAG_TOTAL = 10
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence:true, uniqueness: { case_sensitive: false }
  validates :profile, length: {maximum: 100}

  scope :with_follower_count, -> { joins(:passive_relations)
                                   .select("users.*, COUNT(relations.id) AS follower_count")
                                   .group(:id)}

  def follow(user)
    following << user
  end

  def unfollow(user)
    following.delete(user)
  end

  def following?(user)
    following.exists?(user.id)
  end

  def punished?(user)
    blog_punishment = BlogPunishment.find_by(punisher_id: user.id, punished_id: self.id)
    return false if blog_punishment.nil?
    if blog_punishment.expire_time > Time.current
      return true
    else
      blog_punishment.destroy
      return false
    end
  end
end
