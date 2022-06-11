class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # 画像投稿のimageカラムとして扱う
  has_one_attached :image

  # バリデーション
  validates :place, presence: true
  validates :explaination, presence: true

  # get_imageを定義づけ
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/Unifo2.png')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  # 引数で渡されたユーザidがFavoritesテーブル内に存在するかどうかを調べる
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("place LIKE?", "#{word}")
    elsif search == "partial_match"
      @post = Post.where("place LIKE?", "%#{word}%")
    else
      @post = Post.all
    end
  end

end
