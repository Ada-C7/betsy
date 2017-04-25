Rails.application.routes.draw do

  root 'products#root'
  resources :merchants, only: [:index, :show]
  get "/auth/github/callback", to: "merchants#auth_callback"
  get '/logout', to: "merchants#logout"

  # resources :products
  resources :reviews


  resources :products do
    post '/add_item', to: 'orders#add_item'
  end

  get '/cart', to: 'orders#cart', as: 'cart'
  get '/checkout', to: 'orders#checkout', as: 'checkout'
  resources :orders, only: [:update]
  patch '/checkout/:id', to: 'orders#update_quantity', as: 'qty_update'
  delete '/checkout/:id', to: 'orders#remove_product', as: 'remove_product'

end
