Rails.application.routes.draw do
  root "pages#index"

  # Pages
  get "terms-of-service" => "pages#terms_of_service"
  get "privacy-policy" => "pages#privacy_policy"
  get "contact" => "pages#contact"

  # Accounts
  resources :accounts, param: :name_id
  post "login" => "accounts#login"
  delete "logout" => "accounts#logout"

  # Posts
  get "/posts/load" => "posts#load_more", as: "load_more_posts"
  resources :posts, param: :name_id, except: %i[ edit update ]

  # Reaction
  post "/react/:name_id" => "reactions#react", as: "react"

  # OAuth
  post "oauth" => "oauth#start"
  get "callback" => "oauth#callback"

  # Others
  get "up" => "rails/health#show", as: :rails_health_check

  # Errors
  match "*path", to: "application#routing_error", via: :all
end
