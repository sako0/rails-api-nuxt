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
  get '/api/v1/guideline' => 'api/v1/food_eat#guideline'
  get '/api/v1/get_list_by_code/:id' => 'api/v1/foods#get_list_by_code'
end
