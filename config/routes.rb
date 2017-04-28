Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'categories#index'

  get '/jolly_owl', to: 'users#jolly_owl'
  resources :categories, :except => [:edit, :update, :destroy] do
    resources :products, only: [:index]
  end

  resources :users, :except => [:destroy] do
    resources :products, only: [:index]
    resources :orders, only: [:index]
  end

  get '/users/:user_id/orders/complete', to: 'orders#complete', as: 'user_orders_complete'

  get '/users/:user_id/orders/incomplete', to: 'orders#incomplete', as: 'user_orders_incomplete'

  patch '/products/status/:id', to: 'products#status', as: 'status'

  resources :products
  resources :product do
      resources :reviews, only: [:new, :create]
  end
  resources :reviews, only: [:index, :show]

  resources :users, only: [:index]

  get "/auth/github/callback", to: "sessions#create"
  # get '/login', to: 'sessions#login_form'
  # post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#logout'


  resources :order_items, only: [:update, :destroy, :index]
  post 'products/:id/add', to: 'order_items#create', as: 'new_order_item'
  get '/cart', to: 'order_items#cart', as: 'cart'

  resources :orders, only: [:index, :show]
  #Tutor brought up that this wording may be misleading.
  get '/checkout', to: 'orders#checkout', as: 'checkout'
  #Should we change this controller method name to edit?

  put '/orders/:id', to: 'orders#update', as: 'confirmation'

end
