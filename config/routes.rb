TripFollower2::Application.routes.draw do

  root to: 'static_pages#home'

  # REV: hard to read the blocks if they come one right after the
  # other; too tight.

  resources :users do
    resources :user_followings, only: [:create, :destroy]
    member do
      get :followed_users, :followers, :trip_subscriptions
      #get :trip_subscriptions
    end
  end

  resources :sessions, only: [:new, :create, :destroy]

  resources :trips do
    # REV: careful with tabs
  	resources :trip_administratorings, only: [:create, :destroy]
    resources :trip_whitelistings, only: [:create, :destroy]
    member do
      # REV: still think this should be a nested resource for
      # get/post.
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
