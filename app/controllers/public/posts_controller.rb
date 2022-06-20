class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:top]

  def top
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.order("created_at desc")
    @users = User.order("updated_at desc") # 活動があったユーザから並べる
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿しました！"
      redirect_to "/"
    else
      render:new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "更新しました！"
      redirect_to public_post_path(@post)
    else
      render:edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to '/'
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :image, :place, :explaination, tag_ids: [])
  end
end
