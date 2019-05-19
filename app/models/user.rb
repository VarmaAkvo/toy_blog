class User < ApplicationRecord
  include Taggable

  has_many :articles
  has_many :tagging, class_name: 'Tagging', as: :taggable
  has_many :tags, through: :tagging

  MAXIMUM_TAG_TOTAL = 10
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence:true, uniqueness: { case_sensitive: false }
  validates :profile, length: {maximum: 100}

  def following?(user)
    false
  end

  attr_accessor :tag_list
end
