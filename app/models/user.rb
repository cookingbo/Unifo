class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts,         dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes,         dependent: :destroy

  # フォローしたユーザ(foreign_key(親子関係)でrelationshipのカラムを取ってくる)
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされたユーザ(foreign_key(親子関係)でrelationshipのカラムを取ってくる)
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォロー
  has_many :followings, through: :relationships, source: :followed
  # フォロワー
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_one_attached :profile_image

  # get_imageを定義づけ
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/Unifo2.png')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
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

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}")
    else
      @user = User.all
    end
  end

  enum area: {
    "北アメリカ":0, "南アメリカ":1, "アジア":2, "南アフリカ":3, "オセアニア":4, "ヨーロッパ":5
  }
end
