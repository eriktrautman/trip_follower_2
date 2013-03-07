class TripsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :trip_admin, only: [:edit, :update]
  before_filter :trip_creator, only: [:destroy]

  def index
    @trips = Trip.limit(30)
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = current_user.trips.new(params[:trip])
    if @trip.save
      @trip.trip_administratorings.create!(user: current_user)
      @trip.trip_whitelistings.create!(user: current_user)
      current_user.subscribe_followers_to(@trip)
      flash[:success] = "Your trip has been created!"
      redirect_to @trip
    else
      flash[:error] = "Your trip could not be created"
      render :new
    end
  end

  def show
        @trip = Trip.find(params[:id])
    if request.xhr?
      begin
        if @trip.whitelist_posters
          feed_items = []
          @trip.whitelisted_users.each do |user|
            feed_items += Feed.from_tags_by_user([@trip.hashtag], user)
          end
        else
          feed_items = Feed.from_tags([@trip.hashtag], current_user)
        end
        @feed_items = Feed.sort_feed(feed_items)[0..9] # PAGINATING
      rescue SocketError
        flash.now[:error] = "Could not grab feed media, check your internet connection"
        @feed_items = []
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @feed_items}
    end
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

  def subscribe
    trip = Trip.find(params[:id])
    if trip.subscribe(current_user)
      respond_to do |format|
        format.json { render json: trip }
      end
    else
      respond_to do |format|
        format.json { render json: { failure: true } }
      end
    end
  end

  def unsubscribe
    trip = Trip.find(params[:id])
    if trip.unsubscribe(current_user)
      respond_to do |format|
        format.json { render json: trip }
      end
    else
      respond_to do |format|
        format.json { render json: { failure: true } }
      end
    end
  end

  def subscribers
    @trip = Trip.find(params[:id])
    @subscribers = @trip.subscribed_users
    respond_to do |format|
      format.json { render json: @subscribers }
      format.html { render :subscribers }
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