Rails.application.routes.draw do

  resources :posts
  resources :users
  resources :account_activations, only: :edit
  resources :password_resets, only: [ :new, :edit, :create, :edit, :update ]
  resources :relationships,       only: [:create, :destroy]

  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/help'

  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get '/help' => 'static_pages#help'
  get '/about' => 'static_pages#about'
  get '/home' => 'static_pages#home'
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
end
