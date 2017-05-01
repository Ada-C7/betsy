Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #
  # get '/orders/new', to: "orders#new", as: 'new_order'
  # get '/orders', to: "orders#index", as: 'orders'
  # get '/orders/:id', to: "orders#show", as: 'order'
  root "products#index"
  get '/login', to: 'sessions#login', as: 'login'
  post '/login', to: 'sessions#login'
  post '/logout', to: 'sessions#logout', as: 'logout'

  get "/auth/:provider/callback", to: "sessions#auth_callback", as: 'auth_callback'



  get '/products', to: 'products#index'
  get '/products/new', to:'products#new', as: "new_product"
  post '/products', to: 'products#create'
  get '/products/:id', to:'products#show', as:'product'
  get 'products/:id/edit', to:'products#edit', as: 'edit_product'
  patch '/products/:id', to:'products#update'
  delete '/products/:id', to:'products#destroy'
  get '/products/product_by_merchant/:id', to:'products#product_by_merchant', as: 'product_by_merchant'

get 'merchants/merchants', to:"merchants#merchants", as:"all_merchant"
get 'merchants/products', to:"merchants#products", as:"all_product"
  get '/merchants/:id/orders', to: "merchants#orders", as: "merchant_orders"

  resources :orders
  # get '/orders', to: "orders#index", as: 'orders'
  # get '/orders/new', to: "orders#new", as: 'new_order'
  # post '/orders', to: 'orders#create'
  # get '/orders/:id', to: "orders#show", as: 'order'
  # get '/orders/:id/edit', to: "orders#edit", as: 'edit_order'
  get '/orders/:id/order_summary', to: 'orders#order_summary', as: "order_summary"
  # patch '/orders/:id', to: 'orders#update'
  # delete 'orders/:id', to: 'orders#destroy'

# merchants/:id/orders
  # get '/merchants', to: "merchants#index", as: 'merchants'
  # get "/merchants/new", to: "merchants#new", as: "new_merchants"
  # post "merchants", to: "merchants#create"
  # get '/merchants/:id/edit', to: "merchants#edit", as: "edit_merchant"
  # patch '/merchants/:id', to: "merchants#update"
  #
  # get '/merchants/:id', to: "merchants#show", as: 'merchant'
  resources :categories do
    get 'products', to:'products#index'

  end
  resources :merchants
  resources :products do
    resources :reviews
  end
  # resources :order_products, except: :new

  get '/order_products', to: "order_products#index", as: "order_products"
  get '/products/:product_id/order_products/new', to: "order_products#new", as: "new_order_product"
  post '/order_products', to: "order_products#create"
  delete '/order_products/:id', to: "order_products#destroy", as: "delete_order_product"
  # patch '/order_products/:id', to: "order_products#update", as: "update_order_product"

  resources :order_products, except: [:index, :new, :create, :destroy]
end
