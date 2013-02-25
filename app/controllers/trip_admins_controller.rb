class TripAdminsController < ApplicationController
  before_filter :is_trip_creator, only: [:create, :destroy]

  # Expects an AJAX request to destroy user, returns user
	def destroy
		admin = User.find(params[:id])
		if Trip.find(params[:trip_id]).remove_admin(admin)
			respond_to do |format|
				format.json { render json: admin }
			end
		else
			respond_to do |format|
				format.json {render nothing: true }
			end
		end
	end

	# Expects an AJAX request to create TripAdmin, returns Admin user
	def create
		puts "\n\n USERNAME: #{params[:username]}"
		user = User.find_by_username(params[:username])
		trip = Trip.find(params[:trip_id])
		tripadmin = TripAdmin.new(user: user, trip: trip)
		puts "user: #{user.inspect}"
		puts "trip: #{trip.inspect}"
		puts "tripadmin: #{tripadmin.inspect}"
		if user && trip && tripadmin.save
			respond_to do |format|
				format.json { render json: user }
			end
		else
			render nothing: true
		end
	end

	private

	def is_trip_creator
		trip = Trip.find(params[:trip_id])
		unless trip && trip.creator == current_user
			flash[:error] = "Permission Denied"
			render json: { error: "failure"}
		end
	end

end
