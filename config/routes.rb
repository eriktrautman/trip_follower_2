TripFollower2::Application.routes.draw do

  root to: 'static_pages#home'

  resources :users do
    resources :user_followings, only: [:create, :destroy]
    member do
      get :followed_users, :followers
      #get :trip_subscriptions
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :trips do
  	resources :trip_administratorings, only: [:create, :destroy]
    resources :trip_whitelistings, only: [:create, :destroy]
    member do
      get :subscribers
      post :subscribe
      delete :unsubscribe
    end
  end
  resources :events, except: [:new, :show]

  get "/signin", to: 'sessions#new'
  delete "/signout", to: 'sessions#destroy'
  get "/signup", to: 'users#new'

end
