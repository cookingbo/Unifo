class Post < ApplicationRecord

  belongs_to :user
  has_many :post_comments, dependent: :destory
  has_many :likes, dependent: :destroy

  has_one_attached :image

end
