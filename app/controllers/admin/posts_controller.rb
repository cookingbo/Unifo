class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.order("created_at desc")
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "更新しました！"
      redirect_to admin_post_path(@post)
    else
      render:edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to "/admin"
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :image, :place, :explaination, tag_ids: [])
  end

end
