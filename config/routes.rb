TripFollower2::Application.routes.draw do

  root to: 'static_pages#home'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :life_threads

  get "/signin", to: 'sessions#new'
  delete "/signout", to: 'sessions#destroy'
  get "/signup", to: 'users#new'

end
