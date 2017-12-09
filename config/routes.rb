Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #make sure to define root route!!
  resources :hunts do
    resources :teams, only: [:show, :new, :create, :edit, :update] do
      resources :found_items, only: [:update]
    end
    # are items routes needed?
    resources :items, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :users, only: [:show, :edit, :update]
end
