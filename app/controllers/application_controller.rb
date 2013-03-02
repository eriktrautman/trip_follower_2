class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthorizationHelper

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(  :action => 'new',
                            :controller => 'sessions',
                            :only_path => false,
                            :protocol => 'http'
                          )
    stored = stored_location_for(resource)
    puts "****************************"
    puts "stored: #{stored.inspect}, referer: #{request.referer}!"
    puts "new reg: #{new_user_registration_url}, sign_in: #{sign_in_url}!"
    puts "****************************"
    if stored
      puts "STORED"
      stored
    elsif request.referer == sign_in_url
      if resource
        resource
      else
        puts "SUPERING"
        super
      end
    elsif request.referer == new_user_registration_url
      puts "HOMEPAGING"
      resource
    else
      puts "OTHERWISING"
      request.referer || root_path
    end
  end

end
