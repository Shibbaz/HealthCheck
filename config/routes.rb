require 'sidekiq/web'

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  get "/tests", to: "tests#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
