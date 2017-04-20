Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :merchants, only: [:index, :show]
  get '/login', to: 'merchantss#login_form', as: 'login'
  post '/login', to: 'merchants#login'
  post '/logout', to: 'merchants#logout', as: 'logout'

  resources :products
  resources :reviews

end
