Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :posts do
    resources :comments, shallow: true
  end

  resources :comments, only: [:edit, :update, :destroy]
  resources :users, only: [:show]
  resources :friend_requests, only: [:index, :create, :update]
  resources :friends, controller: :friendships, only: [:index] #show friends list

  root to: "posts#index"
end
