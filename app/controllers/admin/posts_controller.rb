class Admin::PostsController < ApplicationController
  def index
    @posts = Post.order("created_at desc")
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :image, :place, :explaination)
  end

end
