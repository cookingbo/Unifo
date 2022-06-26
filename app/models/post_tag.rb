class PostTag < ApplicationRecord
  
  # 中間テーブル
  belongs_to :post
  belongs_to :tag
end
