class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to public_posts_path
  end

  def index
    @posts = Post.all
  end

  def edit
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :image, :place, :explaination)
  end
end
