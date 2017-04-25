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
  post "/carts/:id/add", to: "orders#add", as: "add_item"
  post "/carts/:id/remove", to: "orders#remove", as: "remove_item"
  get "/carts", to: "orders#index"

  post "/carts/set", to: "orders#set", as: "set_item"

  get "/account", to: "users#account"
end
