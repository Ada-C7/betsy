Rails.application.routes.draw do

  root "products#homepage"

  get "/auth/github/callback", to: "sessions#create"
  delete "/logout", to: "sessions#logout"

  resources :categories do
    get "/products", to: "products#homepage"
  end

  get "/users/:id/products", to: "products#homepage", as: "user_product"

  resources :products, except: :index
  resources :users
  resources :orders, except: [:index, :create, :new]

  get "/carts", to: "orders#index"
  post "/carts/set", to: "orders#set", as: "set_item"
  post "/carts/add", to: "orders#add", as: "add_item"
  get "/carts/checkout", to: "orders#edit", as: "checkout"
  get "/carts/:id/confirmation", to: "orders#confirmation", as: "confirmation"

  get "/merchants", to: "users#index", as: "accounts"
  get "/account", to: "users#show"
  patch "/account", to: "users#update"
  post "/account", to: "users#create"
  get "/account/new", to: "users#new", as: "new_account"
  get "/account/edit", to: "users#edit", as: "edit_account"
  get "/account/products", to: "users#products", as: "account_products"
  get "/account/orders", to: "users#orders", as: "account_orders"

end
