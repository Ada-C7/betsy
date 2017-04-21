Rails.application.routes.draw do

  get 'merchants/new', to: 'merchants#new', as: 'new_merchant'
  post 'merchants', to: 'merchants#create'

  get 'merchants/:id', to: 'merchants#show', as: 'merchant'

  category_constraints = { category: /(Aquamarine)|(Green)|(Maroon)/}
  get 'products(/:category)', to: 'products#index', as: 'products', constraints: category_constraints
  get 'products/:id', to: 'products#show', as: 'product'
  get 'products/new', to: 'products#new', as: 'new_product'

  post 'products', to: 'products#create'

  get 'products/:id/edit', to: 'products#edit', as: 'edit_product'

  post 'products/:id/edit', to: 'products#edit'
  patch 'products/:id', to: 'products#update'

  resources :reviews, only: [:new, :create, :show]
  # post 'reviews', to: 'reviews#create', as: 'root'

  get 'orders/:id/edit', to:'orders#edit', as: 'edit_order'
  patch 'orders/:id', to: 'orders#update'

  # orderedproduct routes
  # get 'orderedproducts', to: 'orderedproducts#index', as: 'orderedproducts'

  post 'orderedproducts/:product_id', to: 'orderedproducts#create', as: 'add_OP'

  get 'orderedproducts/:id/edit', to: "orderedproducts#edit", as: 'edit_op'
end
