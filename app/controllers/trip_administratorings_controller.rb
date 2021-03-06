class TripAdministratoringsController < ApplicationController
	before_filter :authenticate_user!
  before_filter :is_trip_creator, only: [:create, :destroy]


	# Expects an AJAX request to create TripAdministratoring
	# Returns the Admin user upon success
	def create
		user = User.find_by_username(params[:username])
		trip = Trip.find(params[:trip_id])
		tripadmin = TripAdministratoring.new(user: user, trip: trip)
		if user && trip && tripadmin.save
			respond_to do |format|
				format.json { render json: user }
			end
		else
			render json: { failure: true }
		end
	end

  # Expects an AJAX request to destroy user, returns user
	def destroy
		admin = User.find(params[:id])
		if Trip.find(params[:trip_id]).remove_admin(admin)
			respond_to do |format|
				format.json { render json: admin }
			end
		else
			render json: { failure: true }
		end
	end

	private

	def is_trip_creator
		trip = Trip.find(params[:trip_id])
		unless trip && trip.creator == current_user
			render json: { failure: true }
		end
	end

end
