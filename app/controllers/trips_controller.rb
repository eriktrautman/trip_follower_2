class TripsController < ApplicationController
  before_filter :signed_in_user, except: [:show]
  before_filter :correct_user, only: [:edit, :destroy, :update]

  def new
    @trip = Trip.new
  end

  def create
    @trip = current_user.trips.new(params[:trip])
    if @trip.save
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
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(params[:trip])
      flash[:success] = "Successfully updated"
      redirect_to @trip
    else
      flash.now[:error] = @trip.errors.full_messages.first
      render :edit
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

    def correct_user
      trip = current_user.trips.find_by_id(params[:id])
      if trip.nil?
        flash[:error] = "Permission Denied"
        redirect_to root_path
      end
    end

end
