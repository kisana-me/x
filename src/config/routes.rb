Rails.application.routes.draw do
  root "pages#index"

  # Pages
  get "terms-of-service" => "pages#terms_of_service"
  get "privacy-policy" => "pages#privacy_policy"
  get "contact" => "pages#contact"

  # Accounts
  resources :accounts, only: :index
  get "@:name_id", to: "accounts#show", as: :account

  # Posts
  get "posts/load" => "posts#load_more", as: "load_more_posts"
  resources :posts, param: :aid, except: %i[ edit update ]

  # Reaction
  post "react" => "reactions#react", as: "react"

  # Sessions
  get "signin" => "sessions#signin"
  post "signin" => "sessions#post_signin"
  delete "signout" => "sessions#signout"
  # resources :sessions, except: [:new, :create], param: :aid

  # Signup
  get "signup" => "signup#new"
  post "signup" => "signup#create"

  # OAuth
  post "oauth/start" => "oauth#start"
  get "oauth/callback" => "oauth#callback"

  # Settings
  get "settings" => "settings#index"
  get "settings/account" => "settings#account"
  patch "settings/account" => "settings#post_account"
  delete "settings/leave" => "settings#leave"

  # Others
  get "up" => "rails/health#show", as: :rails_health_check

  # Errors
  match "*path", to: "application#routing_error", via: :all
end
