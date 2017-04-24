Rails.application.routes.draw do
    root 'home#index'

    resources :users, except: [:edit, :update, :destroy]
    resources :products, except: [:destroy]
    resources :category, only: [:new, :create] do
        get '/products', to: 'products#index'
    end
    resources :reviews, except: [:edit, :update, :destroy]
    resources :orders, except: [:edit, :update, :destroy]

    get '/auth/:provider/callback', to: 'sessions#create'

    get 'login', to: 'sessions#new', as: 'login'
    post 'login', to: 'sessions#login'
    post 'logout', to: 'sessions#logout', as: 'logout'

    post 'products/:id/cart', to: 'orders#add_product', as: 'add_to_cart'


end
