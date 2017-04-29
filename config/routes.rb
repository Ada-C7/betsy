Rails.application.routes.draw do
  root to: "products#index"

  get 'products/category', to: 'products#category', as: 'category'
  get 'products/category/dog', to: 'products#dog', as: 'dog'
  get 'products/category/cat', to: 'products#cat', as: 'cat'
  get 'products/category/other', to: 'products#other', as: 'other'

  resources :merchants, except: [:new]
# changed to remove new_product_path, delete product_path
  resources :products do
    get 'orders/added_to_cart', to: 'orders#added_to_cart'
    get 'orders/:order_id', to: 'orders#show', as: 'order'
    patch 'orders/:order_id', to: 'orders#update', as: 'update'
    get 'orders/', to: 'orders#index', as: 'orders'
  end
  # resources :orders, except: [:new, :show]


  post 'products/:id/add_to_cart', to: 'orders#add_to_cart', as: 'add_to_cart'
  get 'orders/:id/cart', to: 'orders#cart', as: 'cart'
  patch 'orders/:id/update_qty', to: 'orders#update_qty', as: 'update_quantity'
  delete 'orders/:order_id/orderproduct/:orderproduct_id', to: 'orders#remove_from_cart', as: 'remove_from_cart'
  get 'orders/:id/checkout', to: 'orders#checkout', as: 'checkout'
  patch 'orders/:id/purchase', to: 'orders#purchase', as: 'purchase'
  get 'orders/:id/invoice', to: 'orders#invoice', as: 'invoice'
  patch 'orders/:id/cancel', to: 'orders#cancel', as: 'cancel'
  get 'orders/find_order', to: 'orders#find_order', as: 'find_order'
  post 'orders/find_order', to: 'orders#find'
  get 'orders/:id', to: 'orders#view_order', as: 'view_order'


  post '/products/:id/review', to: 'products#review', as: 'review'
  resources :reviews

  get "/auth/:provider/callback", to: "merchants#login", as: 'auth_callback'
  post '/login', to: 'merchants#login'
  post '/logout', to: 'merchants#logout', as: 'logout'
end
