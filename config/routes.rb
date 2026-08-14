Rails.application.routes.draw do
  get "words", to: "words#index"
  get "words/new", to: "words#new"
  post "words", to: "words#create"
  get "words/:id/edit", to: "words#edit"
  patch "words/:id", to: "words#update"
  delete "words/:id", to: "words#destroy"

  root "users#new"

  post "users", to: "users#create"
  get "users/new", to: "users#new"
end
