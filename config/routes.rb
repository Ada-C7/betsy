Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:index, :show, :create]
  get '/login', to: 'sessions#login_form'
  post '/login', to: 'sessions#login'
  delete '/login', to: 'sessions#logout'

end
