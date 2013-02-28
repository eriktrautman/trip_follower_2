class InstagramsController < ApplicationController


  def index
    @photos = Instagram.recent_photos
  end

end
