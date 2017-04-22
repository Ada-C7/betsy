Rails.application.routes.draw do
  resources :merchants do
    resources :products, only: [:index]
  end

  resources :categories, except: [:destroy] do
    get '/products', to: 'categoryproducts#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
