# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :reject_user, only: [:create]


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

  protected

  # ユーザの論理削除のための記述。退会後は同じアカウントを利用できない。
  def reject_user
    @user = User.find_by(email: params[:user][:email]) # ログイン時に入力されたメールアドレスに対応するユーザが存在するか探す
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.is_deleted == true) # 入力したパスワードが正しく、退会カラムがtrueの時
        flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
        redirect_to new_user_registration_path
      else
        flash[:notice] = "項目を入力してください"
      end
    end
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
