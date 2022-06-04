# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # 退会しているかを判断するメソッド
  def user_state
    ## 【処理内容1】ログイン画面から送られたemailを確認し、Userモデルに該当するemailのアカウントが存在するかを検索する
    @user = User.find_by(email: params[:user][:email])
    ## アカウントを取得できなかった場合、このメソッドを終了する
    return if !@user
    ## 【処理内容2】1のアカウントが存在している場合、そのアカウントのパスワードとログイン画面で入力されたパスワードが一致しているか確認する
    if @user.valid_password?(params[:user][:password]) && !@user.is_deleted
      ## 【処理内容3】
      flash[:danger] = 'お客様は退会済みです。申し訳ございませんが、別のメールアドレスをお使いください。'
      redirect_to new_user_registration_path
    else
      flash[:notice] = "項目を入力してください"
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
