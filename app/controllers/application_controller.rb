class ApplicationController < ActionController::Base
  # デフォルトではemailとpasswordの情報しか操作できないため、操作できる情報(カラム)を増やす
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      "/admin"
    when User
      root_path
    end
  end

  def after_sign_out_path_for(resource)
    if resource == :admin
      new_admin_session_path
    else
      root_path
    end
  end

  protected

  # devise_parameter_sanitizerでkeys内のカラムのデータの操作を可能にする。デフォルトにないカラムは追加しないといけない。
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :university, :area, :country_code, :introduction])
  end

end