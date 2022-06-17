class PostComment < ApplicationRecord

  # 中間テーブル
  belongs_to :user
  belongs_to :post

  validates :comment, presence: true, length: { in: 1..30 }

end
