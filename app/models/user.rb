class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :posts,         dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes,         dependent: :destroy

  # フォローしたユーザ(foreign_key(親子関係)でrelationshipのカラムを取ってくる)
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされたユーザ(foreign_key(親子関係)でrelationshipのカラムを取ってくる)
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォロー一覧
  has_many :followings, through: :relationships, source: :followed
  # フォロワー一覧
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # バリデーション
  validates :name, presence: true
  validates :university, presence: true
  validates :area, presence: true
  validates :introduction, length: { in: 1..100 }

  # ユーザのprofile_imageカラムとして扱う(ActiveStorageを使用するため)
  has_one_attached :profile_image

  # countries gemから情報を持ってくるメソッド
  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
  end


  # get_imageを定義づけ(デフォルト画像はUnifo1.png)
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/Unifo1.png')
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

  # ユーザと投稿検索の定義づけ
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end

  # ゲストログイン時のユーザ情報を登録。パスワードは自動的に作成される。
  def self.guest
    find_or_create_by!(name: '採用ご担当者様', email: 'guest@guest.com', university: 'DMM大学', area: 'アジア', country_code: "JP", introduction: '採用ご担当者様のプロフィールです。') do |user| # データの検索と作成を自動的に判断する
      user.password = SecureRandom.urlsafe_base64 # ランダムな文字列を作成。これでパスワードが自動で作成される
      user.name = "採用ご担当者様"
    end
  end

 # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end

  # エリア選択
  enum area: {
    "北アメリカ":0, "南アメリカ":1, "アジア":2, "南アフリカ":3, "オセアニア":4, "ヨーロッパ":5
  }
end
