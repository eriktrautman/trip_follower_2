class UsersController < ApplicationController

	before_filter :authenticate_user!, except: [:index, :new, :create]
	before_filter :correct_user, only: [:edit, :update, :destroy]


	def index
		@users = User.all
		@followers = current_user.followers if current_user
		@followed_users = current_user.followed_users if current_user
	end

	def show
		@user = User.find(params[:id])
		@followers = @user.followers
		@followed_users = @user.followed_users
		@trips = @user.trips
		@trips_contributed_to = @user.whitelisted_trips.where("trips.creator_id != ?", @user.id).includes(:admins)
	end

	def followers
		@user = User.find(params[:id])
		@followers = @user.followers
	end

	def followed_users
		@user = User.find(params[:id])
		@followed_users = @user.followed_users
	end

	def trip_subscriptions
		@user = User.find(params[:id])
		@subscriptions = @user.subscribed_trips
	end

	private

	def correct_user
		redirect_to root_path unless current_user == User.find_by_id(params[:id])
	end

end
