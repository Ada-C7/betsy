Rails.application.routes.draw do

  root 'products#root'

  get "/auth/github/callback", to: "merchants#auth_callback", as: 'auth_callback'
  get '/logout', to: "merchants#logout"

  resources :products do
    post '/add_item', to: 'orders#add_item'
    get '/categories/new', to: 'products#new_category', as: 'new_category'
    post '/categories', to: 'products#create_category', as: 'categories'
    # resources :categories, only: [:new, :create]
    post '/add_product', to: 'orders#add_product'
  end

  resources :categories do
    get '/products', to: 'products#index'
    #resourses :products, only: [:index]    ----is another way to write this
  end

  resources :reviews

  resources :merchants, only: [:index, :show]
  patch 'products/:id/status', to: 'products#status', as: 'status'

  # get 'products/:id/new_category_product', to: 'products#new_category_product', as: 'add_category'
  # post 'products/:id/', to: 'products#create_category_product'

  get '/cart', to: 'orders#cart', as: 'cart'
  get '/checkout', to: 'orders#checkout', as: 'checkout'
  get '/confirmation/:id', to: 'orders#confirmation', as: 'order_confirmation'
  resources :orders, only: [:update]
  patch '/checkout/:id', to: 'orders#update_quantity', as: 'qty_update'
  delete '/checkout/:id', to: 'orders#remove_product', as: 'remove_product'
end
