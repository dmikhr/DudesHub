Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  resources :panels, only: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "panels#index"
end
