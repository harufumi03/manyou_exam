Rails.application.routes.draw do
  root 'sessions#new'
  resources :tasks, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :labels, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  namespace :admin do
    resources :users
  end

  # get '*path', to: 'application#render_404'
end
