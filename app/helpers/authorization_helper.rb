module AuthorizationHelper

	def trip_creator(user)
		trip = Trip.find(params[:id])
		trip && user == trip.creator
	end	

end