Rails.application.routes.draw do

  root "producs#homepage"

  get "/auth/github/callback", to: "sessions#create"
  delete "/logout", to: "sessions#logout"

  resources :categories do
    get "/products", to: "products#index"
  end

  resources :products
  resources :users
  resources :orders


end
