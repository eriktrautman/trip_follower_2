TripFollower2::Application.routes.draw do

  devise_for :users

  root to: 'static_pages#home'

  resources :users, only: [:index, :show] do
    resources :user_followings, only: [:create, :destroy]
    member do
      get :followed_users, :followers, :trip_subscriptions
      #get :trip_subscriptions
    end
  end

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

end
