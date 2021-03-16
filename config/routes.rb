Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # APIコントローラへのルーティング
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:update]
      resources :food_posts
      resources :sessions, only: [:index, :create]
      resources :profiles, only: [:create]
      resources :foods
      resources :food_eat
    end
  end
end
