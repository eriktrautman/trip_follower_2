class SessionsController < ApplicationController

	def new

	end

	def create
		email = params[:session][:email]
		user = User.find_by_email(email.downcase) unless email.empty?
		if user && user.authenticate(params[:session][:password])
			flash[:success] = "You are now signed in"
			sign_in(user)
			redirect_to_smartly user
		else
			flash[:error] = "The information you entered is incorrect"
			render :new
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
