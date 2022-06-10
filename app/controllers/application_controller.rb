class ApplicationController < ActionController::Base
  # デフォルトではemailとpasswordの情報しか操作できないため、操作できる情報を増やす
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_posts_path
    when User
      "/"
    end
  end

  def after_sign_up_path_for(resource)
    case resource
    when User
      public_user_path(resource)
    end
  end

  def after_sign_out_path_for(resource)
    if resource == :admin
      new_admin_session_path
    else
      "/"
    end
  end

  protected

  # devise_parameter_sanitizerでkeys内のカラムのデータの操作を可能にする。デフォルトでないカラムは追加しないといけない。
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :university, :area, :country, :introduction])
  end

end
