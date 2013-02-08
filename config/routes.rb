TripFollower2::Application.routes.draw do

  root to: 'static_pages#home'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  match "/signin", to: 'sessions#new'
  match "/signout", to: 'sessions#destroy', via: :delete
  match "/signup", to: 'users#new'

end
