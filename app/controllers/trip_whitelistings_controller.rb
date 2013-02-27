class TripWhitelistingsController < ApplicationController
	before_filter :is_trip_admin, only: [:create, :destroy]

	# Expects an AJAX request to create a Whitelisting
	# Returns the Whitelisted user if successful
	def create
		user = User.find_by_username(params[:username])
		trip = Trip.find(params[:trip_id])
		whitelisting = TripWhitelisting.new(user: user, trip: trip)
          # REV: same comment as other file.
		if user && trip && whitelisting.save
			respond_to do |format|
				format.json { render json: user }
			end
		else
			render json: { failure: true }
		end
	end

	# Expects an AJAX request to destroy a Whitelisting
	# Returns the formerly Whitelisted user if successful
	def destroy
		user = User.find(params[:id])
		if Trip.find(params[:trip_id]).remove_whitelisting(user)
			respond_to do |format|
				format.json { render json: user }
			end
		else
			render json: { failure: true }
		end
	end

	private

	def is_trip_admin
		trip = Trip.find(params[:trip_id])
		unless trip && trip.admins.include?(current_user)
			render json: { failure: true }
		end
	end
end
