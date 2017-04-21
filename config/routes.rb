Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get '/orders/new', to: "orders#new", as: 'new_order'
get '/orders', to: "orders#index", as: 'orders'
get '/orders/:id', to: "orders#show", as: 'order'


end
