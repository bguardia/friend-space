Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :posts do
    resources :comments, shallow: true
  end
  resources :comments, only: [:edit, :update, :destroy]

  root to: "posts#index"
end
