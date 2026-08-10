
Rails.application.routes.draw do
  root "users#new"

  post "users", to: "users#create"
  get "users/new", to: "users#new"
end

