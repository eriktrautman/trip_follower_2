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
    if stored
      stored
    elsif request.referer == ( new_user_registration_url || sign_in_url )
      super
    else
      request.referer || root_path
    end
  end

end
