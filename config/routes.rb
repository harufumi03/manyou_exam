Rails.application.routes.draw do
  root 'tasks#index'
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  namespace :admin do
    resources :users
  end
  resources :tasks
  resources :labels

  get '*path', to: 'application#render_404'
end
