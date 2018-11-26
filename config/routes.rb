Rails.application.routes.draw do
  devise_for :users
  root 'users#index'
  resources :records, only: [:new,:create,:edit,:update,:show]
  resources :users, only: [:show,:index]
end
