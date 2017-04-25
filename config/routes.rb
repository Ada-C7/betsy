Rails.application.routes.draw do

  root to: 'products#index'

  get '/vendors/:id/fulfillment', to: 'vendors#fulfillment', as: 'fulfillment'
  get '/vendors/:id/fulfillment/pending', to: 'vendors#fulfillment_pending', as: 'fulfillment_pending'
  get '/vendors/:id/fulfillment/paid', to: 'vendors#fulfillment_paid', as: 'fulfillment_paid'
  get '/vendors/:id/fulfillment/shipped', to: 'vendors#fulfillment_shipped', as: 'fulfillment_shipped'
  get '/vendors/:id/fulfillment/cancelled', to: 'vendors#fulfillment_cancelled', as: 'fulfillment_cancelled'

  get "/vendors", to: "vendors#index"
  get "/vendors/:id", to: "vendors#show", as: "vendor"
  
  resources :orders, only:[:show, :edit, :update]
  get "/cart", to: "orders#show_cart", as: "cart"
  get "/confirmation", to: "orders#confirm", as: "confirm"
  
  resources :orderitems, only:[:create, :update, :destroy]


  resources :orders, except:[:index, :new, :delete]

  patch 'orderitems/:id/cancel', to: 'orderitems#cancel', as: 'cancel'
  patch 'orderitems/:id/ship', to: 'orderitems#ship', as: 'ship'
  resources :orderitems, except:[:index, :new, :edit]

  get "/auth/google_oauth2/callback", to: "sessions#create"
  delete "/logout", to: "sessions#logout", as: "logout"

  resources :categories do
    resources :products, only: [:index]
  end

  resources :vendors do
    resources :products, only: [:index]
  end

  resources :products
  resources :reviews
end
