Rails.application.routes.draw do
  devise_for :users
  root 'users#index'
  resources :records, only: [:new,:update,:create]
end
