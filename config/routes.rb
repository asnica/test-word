Rails.application.routes.draw do

resources :words, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  root "users#new"

  post "users", to: "users#create"
  get "users/new", to: "users#new"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end
