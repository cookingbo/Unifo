Rails.application.routes.draw do
  # 管理者側では新規登録、パスワード変更のルーティングをskipで削除
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 会員側ではパスワード変更のルーティングをskipで削除
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
