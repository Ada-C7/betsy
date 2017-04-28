Rails.application.routes.draw do

  root 'products#root'

  get "/auth/github/callback", to: "merchants#auth_callback", as: 'auth_callback'
  get '/logout', to: "merchants#logout", as: 'logout'

  resources :products do
    get '/categories/new', to: 'products#new_category', as: 'new_category'
    post '/categories', to: 'products#create_category', as: 'categories'
    post '/add_product', to: 'orders#add_product'
  end

  resources :categories do
    get '/products', to: 'products#index'
  end

  resources :reviews

  resources :merchants, only: [:index, :show]
  patch 'products/:id/status', to: 'products#status', as: 'status'

  get '/cart', to: 'orders#cart', as: 'cart'
  get '/checkout', to: 'orders#checkout', as: 'checkout'
  get '/order_confirmation/:id', to: 'orders#confirmation', as: 'order_confirmation'
  resources :orders, only: [:update]
  patch '/checkout/:id', to: 'orders#update_quantity', as: 'qty_update'
  delete '/checkout/:id', to: 'orders#remove_product', as: 'remove_product'
end
