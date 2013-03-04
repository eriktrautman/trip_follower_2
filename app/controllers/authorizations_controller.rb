class AuthorizationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    auth = request.env["omniauth.auth"]
    puts auth
    puts "creds: #{auth["credentials"].inspect}"

    case auth["provider"]
    when "tumblr"
      account_name = auth["extra"]["raw_info"]["name"]
    when "twitter"
      account_name = auth.extra.raw_info.screen_name
    else
      account_name = nil
    end
    
    new_auth = current_user.authorizations.build( 
                        provider: auth["provider"],
                        uid: auth["uid"],
                        token: auth["credentials"]["token"],
                        secret: auth["credentials"]["secret"],
                        account_name: account_name  )
    if new_auth.save
      flash[:success] = "Authorization successful."
      redirect_to authorizations_url
    else
      flash[:error] = "Authorization was unsuccessful."
      puts "ERRORS: #{new_auth.errors.full_messages}"
      redirect_to authorizations_url
    end
  end

  def index
    @authorizations = current_user.authorizations if current_user
    auth_providers = @authorizations.map(&:provider)
    all_providers = [   "twitter",
                          "instagram",
                          "tumblr",
                          "flickr" ]
    @unused_providers = all_providers - auth_providers
  end

  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    @authorization.destroy
    flash[:notice] = "Successfully removed authorization."
    redirect_to authorizations_url
  end


end
