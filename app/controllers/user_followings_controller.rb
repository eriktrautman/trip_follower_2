class UserFollowingsController < ApplicationController
	before_filter :signed_in_user

	def create
		@user = User.find(params[:user_following][:followed_id])
		current_user.follow!(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
			format.json { render json: @user }
		end
	end

	def destroy
		@user = User.find(params[:user_id])
		current_user.unfollow!(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js { puts "WE DID IT YEAH" }
			format.json { render json: @user }
		end
	end

end
