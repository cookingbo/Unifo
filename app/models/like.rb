class Like < ApplicationRecord
  
  # 中間テーブル
  belongs_to :post
  belongs_to :user
  
end
