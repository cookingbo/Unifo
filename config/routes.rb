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

    root to: "public/homes#top"
    get "about" => 'public/homes#about'

  # 会員側ルーティング
  namespace :public do
    get "search" => "searches#search"
    # postsに対してlikesとpost_commentsをネストする。
    resources :posts do
      resource :likes, only: [:create, :destroy] # 1つの投稿に対して1回だけしかいいねできないため、resourceとすることでいいねのidを含めない形にした
      resources :post_comments, only: [:create, :destroy]
    end
    # usersに対してrelationshipsをネストする。
    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy] # 1人のユーザに対して一度しかフォローできないため、resourceとすることでidを含めない形にした。
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
    end
  end

  # 管理者側ルーティング
  namespace :admin do
    root to: "homes#top"
    resources :posts, only: [:index, :show]
    resources :users, only: [:index, :show, :edit, :update]
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
