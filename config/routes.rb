Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :posts do
    resources :comments, shallow: true
    resources :likes, only: [:create], likeable_type: "Post"
  end

  resources :likes, only: [:destroy]

  resources :comments, only: [:edit, :update, :destroy]
  resources :users, only: [:show, :index]
  resources :friend_requests, only: [:index, :create, :update]
  resources :friends, controller: :friendships, only: [:index] #show friends list
  
  resources :pokes, only: [:create]

  resources :notifications, only: [:index, :update]
  resource :profile, except: [:show, :destroy]
  resolve('Profile') { [:profile] }

  get '/privacy-policy', controller: :privacy_policy, action: :show
  root to: "posts#index"
end
