Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create]
      post 'login', to: 'users#login'
      delete 'logout', to: 'users#logout'

      resources :lists, only: %i[index create update destroy] do
        resources :list_items, only: %i[index create update destroy]
      end
    end
  end
end
