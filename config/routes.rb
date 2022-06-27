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

    root to: "public/posts#top"
    get "about" => 'public/homes#about'

  # 会員側ルーティング
  namespace :public do
    # 検索結果画面
    get "search" => "searches#search"
    # 退会確認画面
    get "/users/:id/unsubscribe" => "users#unsubscribe", as: "unsubscribe"
    # 論理削除用のルーティング
    patch "/users/:id/withdrawal" => "users#withdrawal", as: "withdrawal"
    # postsに対してlikesとpost_commentsをネストする。
    resources :posts, except: [:index] do
      resource :likes, only: [:create, :destroy] # 1つの投稿に対して1回だけしかいいねできないため、resourceとすることでいいねのidを含めない形にした
      resources :post_comments, only: [:create, :destroy]
    end
    # usersに対してrelationshipsをネストする。
    resources :users, only: [:show, :edit, :update] do
      member do # user.idが含まれているurlを作成することができる
        get :likes
      end
      resource :relationships, only: [:create, :destroy] # 1人のユーザに対して一度しかフォローできないため、resourceとすることでidを含めない形にした。
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
    end
  end

  # 管理者側ルーティング
  namespace :admin do
    root to: "posts#index"
    resources :posts, only: [:show, :edit, :update, :destroy]
    resources :users, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy] # 1人のユーザに対して一度しかフォローできないため、resourceとすることでidを含めない形にした。
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
    end
  end

  # ゲストログイン用のパス
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end