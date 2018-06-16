Rails.application.routes.draw do
  get 'users/index'

  get 'users/show'

  get '/' => "home#top"
  get "about" => "home#about"

  resources :posts
  resources :events
  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }
  resources :users, only: [:index, :show]
  root 'pages#index'
  get 'pages/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
