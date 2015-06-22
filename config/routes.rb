Rails.application.routes.draw do
  root 'homes#index'
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  resources :projects, only: [:new, :create, :index, :show] do
    resources :project_memberships, only: :create, as: :memberships
    resources :slack_invitations, only: [:create]
  end
end
