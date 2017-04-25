Rails.application.routes.draw do

  root to: 'products#index'

  get "/vendors", to: "vendors#index"
  get "/vendors/:id", to: "vendors#show", as: "vendor"

  get "/auth/google_oauth2/callback", to: "sessions#create"

  resources :orders, except:[:index, :new, :delete]
  resources :orderitems, except:[:index, :new, :edit]

  resources :categories do
    resources :products, only: [:index]
  end

  resources :vendors do
    resources :products, only: [:index]
  end

  resources :products
  resources :reviews
end
