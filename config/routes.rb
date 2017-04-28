Rails.application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback'

  get 'carts/show', to: 'carts#show'
  delete 'carts/show', to: 'order_items#destroy', as: :destroy_item

  root 'products#index'
  post '/logout', to: 'sessions#logout', as: 'logout'

  patch '/merchants/:merchant_id/products/:id', to: 'products#product_status', as: "product_status"

  resources :merchants do
    resources :products
  end

  resources :orders

  resources :categories, only: [:index, :new, :create] do
    resources :products, only: [:index]
  end

  resources :reviews, only: [:create]

  resources :products

  # resources :carts, only: [:show] do
  #   resources :order_items, only: [:destroy]
  # end

  resources :order_items, only: [:create, :update, :destroy]

  get 'merchants/:id/account/products', to: "merchants#products", as: "account_products"
  get 'merchants/:id/account/orders', to: "merchants#orders", as: "account_orders"

  get "/carts/show/payment/", to: "payments#new", as: "new_payment"
  patch "/carts/show/payment/", to: "payments#update", as: "update_payment"

  get "/carts/show/payment_confirmation", to: "payments#payment_confirmation", as: "payment_confirmation"

end
