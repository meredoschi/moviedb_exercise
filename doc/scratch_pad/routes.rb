Rails.application.routes.draw do
  resources :categories
  devise_for :users
  root 'movies#index'
  authenticate :user do
    resources :movies, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :movies, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
