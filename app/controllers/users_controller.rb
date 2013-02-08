class UsersController < ApplicationController

	def index
		@users = User.all
	end
	
	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "Welcome! Your account was successfully created."
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
			redirect_to @user
		else
			flash.now[:error] = "There was a problem with the information you entered"
			render :edit
		end
	end

end
