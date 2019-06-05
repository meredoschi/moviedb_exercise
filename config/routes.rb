Rails.application.routes.draw do
  resources :movies
  resources :categories
  devise_for :users
  root 'movies#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
