class Relationship < ApplicationRecord

  # 本来ならbelongs_to :userだがどっちのユーザかわからなくなるため使い分けている
  # しかしデータはuserテーブルからなのでclass_nameの記述を行う
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

end
