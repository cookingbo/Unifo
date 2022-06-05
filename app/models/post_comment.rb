class PostComment < ApplicationRecord

  # 中間テーブル
  belongs_to :user
  belongs_to :post

end
