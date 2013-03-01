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
    @instagram_photos = Instagram.photos_by_tag(@trip.hashtag)
    @twitter_tweets = twitter_search_by_tag(@trip.hashtag)
    @tumbles = tumblr_search_by_tag(@trip.hashtag)
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

    def twitter_search_by_tag(hashtag)
      # Users the "twitter" gem from https://github.com/sferik/twitter

      Twitter.configure do |config|
        config.consumer_key = "QVim65jLuVeoo7phUAP0AQ"
        config.consumer_secret = "5tMM645CWOmHwZKcf8xbIVCbRhPHYzMAkmhwvwX7s"
        config.oauth_token = "313316959-gic7hb72LjHqQ1fmE914c1hUuuN51pA3RBzyOA7c"
        config.oauth_token_secret = "vPhMqtGJOww0QmKrulUjSCpB2yoyxQGWfMQGcTI2knM"
      end

      tweets = Twitter.search("##{hashtag}").results.map do |tweet|
        { :created_at   => tweet.attrs[:created_at],
          :text         => tweet.attrs[:text],
          :source       => tweet.attrs[:source],
          :username     => tweet.attrs[:user][:screen_name],
          :user_image   => tweet.attrs[:user][:profile_image_url],
          :geo          => tweet.attrs[:geo],
          :coordinates  => tweet.attrs[:coordinates],
          :source       => tweet.attrs[:source] }
          #:url          => tweet.attrs[:entities][:urls][0][:display_url] }
      end
    end

    def tumblr_search_by_tag(hashtag)
      # Doesn't use any gems at all yet

      consumer_key = "aX3GtjNdUNH8Q8ZUBoZ1HbrTBYh9acrIdbWd99qtu1M8RXx2NU"
      resource = RestClient::Resource.new "http://api.tumblr.com/v2/tagged?tag=#{hashtag}&api_key=#{consumer_key}"
      response = resource.get
      parsed_response = JSON.parse(response)
      tumbles = parsed_response["response"].map do |post|
        tumble = { :blog_name    => post["blog_name"],
                  :post_id      => post["id"],
                  :url          => post["post_url"],
                  :type         => post["type"],
                  :timestamp    => post["timestamp"],
                  :date         => post["date"]
                   }
        case post["type"]
        when "text"
          tumble[:title]  = post["title"]
          tumble[:body]   = post["body"]
        when "photo"
          tumble[:caption]= post["caption"]
        when "video"
          tumble[:caption]= post["caption"]
          tumble[:html5]  = post["html5_capable"]
          tumble[:player] = post["player"]
        else
        end
        tumble
      end
      puts tumbles
      tumbles
    end
end
