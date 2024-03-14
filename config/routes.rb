Rails.application.routes.draw do
  get 'user/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users, only: [:create] do
    collection do
      post 'create_client', to: 'users#create_client'
    end
  end
end
