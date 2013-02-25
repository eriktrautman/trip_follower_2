TripFollower2::Application.routes.draw do

  root to: 'static_pages#home'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :trips do
  	resources :trip_admins, only: [:create, :destroy]
    resources :trip_whitelistings, only: [:create, :destroy]
  end
  resources :events, except: [:new, :show]

  get "/signin", to: 'sessions#new'
  delete "/signout", to: 'sessions#destroy'
  get "/signup", to: 'users#new'

end
