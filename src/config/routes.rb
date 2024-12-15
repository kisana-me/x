Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "general_pages#index"

  # Accounts
  resources :accounts, param: :name_id
  post "login" => "accounts#login"
  delete "logout" => "accounts#logout"

  # Posts
  get "/posts/load" => "posts#load_more", as: "load_more_posts"
  resources :posts, param: :name_id, except: %i[ edit update ]

  # Reaction
  post "/react/:name_id" => "reactions#react", as: "react"
end
