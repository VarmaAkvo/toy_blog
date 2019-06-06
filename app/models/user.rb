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

  scope :with_tag_strings, -> { joins(:tags)
                               .select("users.*, string_agg(tags.name, ' ') AS tag_strings")
                               .group(:id)}
  scope :tag_strings, -> { joins(:tags)
                          .select("users.id, string_agg(tags.name, ' ') AS tag_strings")
                          .group(:id)}
  scope :follower_count, -> { joins(:followers)
                              .select("users.id, COUNT(relations.id) AS follower_count")
                              .group(:id)}
  scope :with_tag_strings_and_follower_count, -> {
     select('users.*, t.tag_strings, f.follower_count')
    .joins("LEFT OUTER JOIN (#{follower_count.to_sql}) AS f ON f.id = users.id
            LEFT OUTER JOIN (#{tag_strings.to_sql}) AS t ON t.id = users.id")
  }

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
  # 用于current_user
  def get_follower_count
    followers.count
  end
  # 用于current_user
  def get_tag_strings
    tags.pluck(:name).join(' ')
  end

  attr_accessor :tag_list
end
