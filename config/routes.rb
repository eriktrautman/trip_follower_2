TripFollower2::Application.routes.draw do

  root to: 'static_pages#home'

  resources :users


end
