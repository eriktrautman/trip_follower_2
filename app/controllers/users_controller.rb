class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:show, :edit, :update, :destroy]
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

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "Welcome! Your account was successfully created."
			sign_in(@user)
			redirect_to @user
		else
			flash.now[:error] = "There was a problem with the information you entered"
			render :new
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user && @user.update_attributes(params[:user])
			flash[:success] = "You've successfully update your account"
			sign_in(@user)
			redirect_to @user
		else
			flash.now[:error] = "There was a problem with the information you entered"
			render :edit
		end
	end

	def followers
		@user = User.find(params[:id])
		@followers = @user.followers
	end

	def followed_users
		@user = User.find(params[:id])
		@followed_users = @user.followed_users
	end

	private

	def correct_user
		redirect_to root_path unless current_user?(User.find_by_id(params[:id]))
	end

end
