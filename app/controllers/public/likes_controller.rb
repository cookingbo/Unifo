class Public::LikesController < ApplicationController

  def create
    @post = Post.find(params[:post_id]) # 中間テーブルからpost_idを取得
    like = current_user.likes.new(post_id: @post.id)
    like.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post_id: @post.id) # 条件(post_idが@post.idと同じもの)を指定して最初の1件を取得
    like.destroy
  end

end
