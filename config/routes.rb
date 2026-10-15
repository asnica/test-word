Rails.application.routes.draw do
  resources :words, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]
  resources :tags, only: [ :index, :new, :create, :edit, :update, :destroy ]
  
  resources :quizzes, only: [:index, :create, :show] do
  patch :answer, on: :member
  get :answers, on: :member
  post :grade, on: :member
  get :result, on: :member
  post :retry, on: :member
end

resources :rankings, only: [:index]

  root "users#new"

  post "users", to: "users#create"
  get "users/new", to: "users#new"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end
