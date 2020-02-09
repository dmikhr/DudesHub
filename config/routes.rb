require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  mount Sidekiq::Web => '/sidekiq'

  resources :repos, only: [:index] do
    patch :add_to_monitored, on: :member
    patch :remove_from_monitored, on: :member
    get :monitor, on: :collection
    get :not_monitor, on: :collection
    post :refresh, on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "repos#index"
end
