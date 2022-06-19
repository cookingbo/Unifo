class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user
  has_many :post_comments,             dependent: :destroy
  has_many :likes,                     dependent: :destroy
  has_many :post_tags,                 dependent: :destroy
  has_many :tags, through: :post_tags, dependent: :destroy

  # 画像投稿のimageカラムとして扱う(ActiveStorageを使用するため)
  has_one_attached :image

  # バリデーション
  validates :place, length: { in: 1..20 }
  validates :explaination, length: { in: 1..200 }

  # get_imageを定義づけ(デフォルト画像はUnifo1.png)
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/Unifo1.png')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  # 引数で渡されたユーザidがFavoritesテーブル内に存在するかどうかを調べる
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  # 検索欄で打ち込まれた情報を基に振り分ける
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
