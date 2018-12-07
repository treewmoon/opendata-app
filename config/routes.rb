Rails.application.routes.draw do
  devise_for :users
  root 'users#index'

  resources :records, only: [:new,:create,:edit,:update,:show] do
    member do
        get 'new_next'
        get 'new_last'
        patch 'set_goal'
        patch 'set_opponent'
    end
  end
  resources :users, only: [:show,:index]
end
