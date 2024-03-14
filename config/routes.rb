Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post 'create_client', to: 'users#create_client'

  resources :cities, only: [:create]
  resources :cabs, only: %i[create update]
end
