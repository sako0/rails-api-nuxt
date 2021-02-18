Rails.application.routes.draw do
  #Routesツール使用の際にエラーがでてしまうため記載
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # APIコントローラへのルーティング
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:index, :show]
      resources :sessions, only: [:index]
    end
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
end
