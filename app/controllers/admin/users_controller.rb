class Admin::UsersController < ApplicationController

  def index
    @users = User.order("created_at desc")
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order("created_at desc")
  end

  def edit
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:name, :university, :area, :country_code, :country, :introduction, :email, :password, :is_deleted, :profile_image)
  end

end
