class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts,         dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes,         dependent: :destroy

  # フォローしたユーザ(foreign_key(親子関係)でrelationshipのカラムを取ってくる)
  has_many :relationships, class_name: "Relationship", foreign_key: follower_id, dependent: :destroy
  # フォローされたユーザ(foreign_key(親子関係)でrelationshipのカラムを取ってくる)
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: followed_id, dependent: :destroy
  # フォロー
  has_many :followings, through: :relationships, source: :followed
  # フォロワー
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image1.png'
  end

  def full_name
    self.last_name + " " + self.first_name
  end

  # フォローした時
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
　# フォローを外すとき
　def unfollow(user_id)
　  relationships.find_by(followed_id: user_id).destroy
　end
　# フォローしているか判定
　def following?(user)
　  followings.include?(user)
　end
end
