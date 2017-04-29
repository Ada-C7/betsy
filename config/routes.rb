Rails.application.routes.draw do
    root 'home#index'

    resources :users, except: [:edit, :update, :destroy] do
        resources :products, only: [:index, :edit, :update]
        get '/orders', to: 'orders#index'
    end
    resources :orders, except: [:destroy]
    resources :reviews, only: [:show, :edit, :update, :destroy]

    resources :products, except: [:destroy] do
        resources :reviews, only: [:new, :create, :new]
    end

    resources :categories, only: [:new, :create, :show] do
        get '/products', to: 'products#index'
    end

    post '/orders/:id/updatestatus', to: 'orders#update_status', as: 'update_status'
    post '/products/:id/addcategory', to: 'products#add_category'
    delete '/products/:id/removecategory', to: 'products#remove_category', as: 'remove_category'
    get '/auth/:provider/callback', to: 'sessions#create', as: 'auth_callback'

    get 'login', to: 'sessions#new', as: 'login'
    post 'login', to: 'sessions#login'
    post 'logout', to: 'sessions#logout', as: 'logout'

    post 'products/:id/cart', to: 'orders#add_product', as: 'add_to_cart'
    post 'orders/:id/update', to: 'orders#update_quantity'

    delete '/orders/:id/remove', to: 'orders#remove_product'

    get 'checkout/confirmation', to: 'orders#confirm', as: 'confirmation'
end
