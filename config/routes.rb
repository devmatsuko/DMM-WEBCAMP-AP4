Rails.application.routes.draw do
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update] do
    # URL:/user/:user_id/relationships
    resource :relationships, only: [:create, :destroy]
    # フォロー一覧、フォロワー一覧へのルーティング
    # memberを書くことでURLにidが加わる。ex)/users/:id/following
    member do
      get :following, :followers
    end
  end
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  root 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
end