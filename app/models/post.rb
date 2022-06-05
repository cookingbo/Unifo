class Post < ApplicationRecord

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # 画像投稿のimageカラムとして扱う
  has_one_attached :image

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image1.png')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

end
