Rails.application.routes.draw do

  root "products#homepage"

  get "/auth/github/callback", to: "sessions#create"
  delete "/logout", to: "sessions#logout"

  resources :categories do
    get "/products", to: "products#homepage"
  end

  resources :products, except: :index
  resources :users
  resources :orders, except: [:index, :create, :new, :destroy]
  post "/orders/:id/add", to: "orders#add", as: "add_item"
  post "/orders/:id/remove", to: "orders#remove", as: "remove_item"
  get "/carts", to: "orders#index"

  get "/account", to: "users#account"
end
