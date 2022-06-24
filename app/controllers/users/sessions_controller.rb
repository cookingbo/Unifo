class Users::SessionsController < Devise::SessionsController

  def guest_sign_in
    user = User.guest
    sign_in user
    flash[:notice] = '採用ご担当者様がログインしました。'
    redirect_to "/"
  end
end