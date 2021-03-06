class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @word = params[:word]
    @search = params[:search]
    @range = params[:range]# 検索モデルの情報
    if @range == "ユーザ"# 検索モデルで条件分岐
      @users = User.looks(params[:search], params[:word])# 選択された検索方法、検索ワードの情報
    else
      @posts = Post.looks(params[:search], params[:word])# 選択された検索方法、検索ワードの情報
    end
  end
  
end
