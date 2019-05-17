class User < ApplicationRecord
  has_many :articles
  has_many :tagging, class_name: 'Tagging', as: :taggable
  has_many :tags, through: :tagging
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence:true, uniqueness: { case_sensitive: false }

  def following?(user)
    false
  end
end
