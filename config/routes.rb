Rails.application.routes.draw do

  root "products#homepage"

  get "/auth/github/callback", to: "sessions#create"
  delete "/logout", to: "sessions#logout"

  resources :categories do
    get "/products", to: "products#homepage"
  end

  resources :products, except: :index
  resources :users
  resources :orders

  get "/merchants", to: "users#index", as: "accounts"
  get "/account", to: "users#show"
  patch "/account", to: "users#update"
  post "/account", to: "users#create"
  get "/account/new", to: "users#new", as: "new_account"
  get "/account/edit", to: "users#edit", as: "edit_account"
  get "/account/products", to: "users#products", as: "account_products"
  get "/account/orders", to: "users#orders", as: "account_orders"

end
