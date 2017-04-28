Rails.application.routes.draw do

  root "products#homepage"

  get "/auth/github/callback", to: "sessions#create"
  delete "/logout", to: "sessions#logout"

  get "/categories/:id/products", to: "products#browse_products", search_term: 'category', as: "category_products"

  get "/merchants/:id/products", to: "products#browse_products", search_term: 'user', as: "user_products"

  resources :products, except: [:index, :destroy]
  delete "products/:id", to: "products#retire", as: 'retire_product'
  resources :categories, only: [:new, :create]

  post '/products/:id/review', to: 'products#review', as: 'review'

  resources :orders, only: [:show, :update, :destroy]
  patch "/orders/:order_item_id/shipped", to: "orders#shipped", as: "shipped"
  patch "orders/:order_item_id/cancelled", to: "orders#cancelled", as: "cancelled"

  get "/carts", to: "orders#index"
  post "/carts/set", to: "orders#set", as: "set_item"
  post "/carts/add", to: "orders#add", as: "add_item"
  get "/carts/checkout", to: "orders#edit", as: "checkout"
  get "/carts/:id/confirmation", to: "orders#confirmation", as: "confirmation"

  get "/merchants", to: "users#index", as: "accounts"
  get "/account", to: "users#show"
  patch "/account", to: "users#update"
  get "/account/edit", to: "users#edit", as: "edit_account"
  get "/account/products", to: "users#products", as: "account_products"
  get "/account/orders", to: "users#orders", as: "account_orders"

end
