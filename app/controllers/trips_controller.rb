class TripsController < ApplicationController
  before_filter :signed_in_user, except: [:show]
  before_filter :trip_admin, only: [:edit, :update]
  before_filter :trip_creator, only: [:destroy]

  def new
    @trip = Trip.new
  end

  def create
    @trip = current_user.trips.new(params[:trip])
    if @trip.save
      TripAdministratoring.create!(user: current_user, trip: @trip)
      TripWhitelisting.create!(user: current_user, trip: @trip)
      flash[:success] = "Your trip has been created!"
      redirect_to current_user
    else
      flash[:error] = "Your trip could not be created"
      render :new
    end
  end

  def show
    @trip = Trip.find(params[:id])
  end

  def edit
    @trip = Trip.includes(:creator).find(params[:id])
    @admins = @trip.admins
    @wl_users = @trip.whitelisted_users
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(params[:trip])
      respond_to do |format|
        format.html do
          flash[:success] = "Successfully updated"
          redirect_to @trip
        end
        format.json do
          render json: @trip
        end
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:error] = @trip.errors.full_messages.first
          render :edit
        end
        format.json { render json: { failure: true } }
      end
    end
  end

  def destroy
    trip = Trip.find(params[:id])
    if trip.delete
      flash[:success] = "The trip was successfully deleted"
      redirect_to current_user
    else
      flash[:error] = "The trip could not be deleted"
      redirect_to trip
    end
  end

  private

    def trip_creator
      trip = current_user.trips.find_by_id(params[:id])
      if trip.nil?
        flash[:error] = "Permission Denied"
        redirect_to root_path
      end
    end

    def trip_admin
      trip = Trip.find_by_id(params[:id])
      unless trip && trip.admins.include?(current_user)
        flash[:error] = "Permission Denied"
        redirect_to root_path
      end
    end
end
