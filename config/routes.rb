Rails.application.routes.draw do

  root 'products#root'

  get "/auth/github/callback", to: "merchants#auth_callback"
  get '/logout', to: "merchants#logout"

  resources :categories do
    get '/products', to: 'products#index'
    #resourses :products, only: [:index]    ----is another way to write this
  end

  resources :reviews

  resources :merchants, only: [:index, :show]
  patch 'products/:id/status', to: 'products#status', as: 'status'

  resources :products do
    post '/add_product', to: 'orders#add_product'
  end

  get '/cart', to: 'orders#cart', as: 'cart'
  get '/checkout', to: 'orders#checkout', as: 'checkout'
  get '/confirmation', to: 'order#confirmation', as: 'order_confirmation'

  resources :orders, only: [:update]
  patch '/checkout/:id', to: 'orders#update_quantity', as: 'qty_update'
  delete '/checkout/:id', to: 'orders#remove_product', as: 'remove_product'
end
