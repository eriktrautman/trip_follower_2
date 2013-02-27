class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include AuthorizationHelper

  # def after_sign_in_path_for(resource)
  #   current_user_path
  # end

  # def after_sign_in_path_for(resource)
  #   sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
  #   if request.referer == sign_in_url
  #     super
  #   else
  #     stored_location_for(resource) || request.referer || root_path
  #   end
  # end

end
