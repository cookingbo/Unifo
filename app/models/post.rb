class Post < ApplicationRecord

  belongs_to :user
  has_many :post_comments, dependent: :destory
  has_many :likes, dependent: :destroy
  
  # 画像投稿のimageカラムとして扱う
  has_one_attached :image

end
