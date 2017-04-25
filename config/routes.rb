Rails.application.routes.draw do

  root "products#homepage"

  get "/auth/github/callback", to: "sessions#create"
  delete "/logout", to: "sessions#logout"

  resources :categories do
    get "/products", to: "products#homepage"
  end

  resources :products, except: :index
  resources :users
  resources :orders, except: [:index, :create, :new]

  get "/carts", to: "orders#index"
  post "/carts/set", to: "orders#set", as: "set_item"
  post "/carts/add", to: "orders#add", as: "add_item"
  get "/carts/checkout", to: "orders#edit", as: "checkout"
  get "/carts/:id/confirmation", to: "orders#confirmation", as: "confirmation"

  get "/account", to: "users#account"
end
