Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # APIコントローラへのルーティング
  namespace :api, { format: 'json' } do
    mount ActionCable.server => '/cable'
    namespace :v1 do
      resources :users, only: [:index, :show]
      resources :microposts
      resources :sessions, only: [:index, :create]
      resources :profiles, only: [:create]
    end
  end
end
