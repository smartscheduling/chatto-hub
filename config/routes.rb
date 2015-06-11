Rails.application.routes.draw do
  root 'homes#index'
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  resources :projects, only: [:new, :create, :index]
end
