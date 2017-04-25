Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#root'
  resources :merchants, only: [:index, :show]
  get "/auth/github/callback", to: "merchants#auth_callback"
  get '/logout', to: "merchants#logout"
  # get '/login', to: 'merchantss#login_form', as: 'login'
  # post '/login', to: 'merchants#login'
  # post '/logout', to: 'merchants#logout', as: 'logout'
  resources :categories do
    get '/products', to: 'products#index'
    #resourses :products, only: [:index]    ----is another way to write this
  end


  resources :products
  patch 'products/:id/status', to: 'products#status', as: 'status'

  resources :reviews

end
