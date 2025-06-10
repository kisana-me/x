Rails.application.routes.draw do
  root "pages#index"
  get "terms" => "pages#terms"
  get "privacy" => "pages#privacy"
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

  # errors
  unless Rails.env.development?
    get "*path", to: "application#render_404"
    post "*path", to: "application#render_404"
    put "*path", to: "application#render_404"
    patch "*path", to: "application#render_404"
    delete "*path", to: "application#render_404"
    match "*path", to: "application#render_404", via: :options
  end
end
