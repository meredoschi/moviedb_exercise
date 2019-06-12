# frozen_string_literal: true

Rails.application.routes.draw do
  #  resources :movies
  resources :categories
  devise_for :users
  root 'movies#index'
  authenticate :user do
    resources :movies, only: %i[new create edit update destroy]
    resources :ratings, except: %i[edit update]
  end
  resources :movies, only: %i[index show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
