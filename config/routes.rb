Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #make sure to define root route!!
  resources :hunts
  resources :teams, only: [:show]
  resources :users, only: [:edit, :update]
end
