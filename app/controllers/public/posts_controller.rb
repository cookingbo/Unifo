class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:top]

  def top
    # tag_idがまず存在するか定義する。その後、存在する場合はtag_idを持つ投稿を表示し、存在しなければ自分とフォローしているユーザの投稿を降順で表示。(following_idsはrailsがアソシエーション時に自動作成)
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.where(user_id: [current_user.id, *current_user.following_ids]).order("created_at desc")
    @users = User.order("current_sign_in_at desc").limit(5) # 活動があったユーザから並べる
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