class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :unsubscribe]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order("created_at desc")
  end

  def withdrawal
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    # 取得したidを持つ@userのis_deletedカラムをtrueに更新することで退会状態を作る
    @user.update(is_deleted: true)
    # セッションをリセットすることで、今まで保持していたデータを削除できる。セキュリティー面も踏まえて明示的に削除する。
    reset_session
    flash[:notice] = "退会処理を実行致しました"
    redirect_to "/"
  end

  def unsubscribe
  end

  def likes
    @user = User.find(params[:id])
    likes = Like.where(user_id: @user.id).pluck(:post_id) # 投稿に紐づいたuser_idと取得したidが同じ情報を持ったいいねを探し、pluckでpost_idカラムのすべてを取得する。
    @like_posts = Post.find(likes) # 上記の内容に紐づいた投稿を探す
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "更新できました！"
      redirect_to public_user_path(@user)
    else
      render:edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :university, :area, :country_code, :introduction, :is_deleted, :profile_image)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "採用ご担当者様"
      flash[:notice] =  '採用ご担当者様はプロフィール編集画面へ遷移できません。'
      redirect_to public_user_path(current_user)
    end
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to public_user_path(current_user)
    end
  end

end
