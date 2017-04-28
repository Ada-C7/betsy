Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root "products#top_products"

  get "/auth/:provider/callback", to: "merchants#create" , as: "auth_callback"
  delete 'logout', to: "merchants#logout"

  resources :merchants, only: [:show, :index] do
    resources :products, only: [:index, :new, :create, :edit, :update]
  end

  get "merchants/:id/orders/:order_id", to: "merchants#show_merchants_order", as: "merchant_order_view"

  resources :products, except:[:destroy] do
    member do
      patch :retire
    end
  end

  patch 'order_products/:id/ship', to: 'order_products#ship', as: 'ship_order_product'

  resources :reviews, only: [:create]

  resources :orders, except: [:index, :destroy] do
    member do
      put :cancel
    end
  end

  resources :order_products, except: [:index, :new, :show] 

  get "shopping_cart", to: 'orders#shopping_cart'

  resources :categories, only: [:index, :new, :create, :show]

end
