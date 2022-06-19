class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.order("created_at desc")
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order("created_at desc")
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "会員情報を更新しました。"
      redirect_to admin_user_path(@user)
    else
      render:edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :university, :area, :country_code, :introduction, :is_deleted, :profile_image)
  end

end
