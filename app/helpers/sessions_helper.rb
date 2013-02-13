module SessionsHelper

	def sign_in(user)
		cookies.permanent[:session_token] = user.session_token
		@current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user
		@current_user ||= User.find_by_session_token(cookies[:session_token])
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user?(user)
		current_user == user
	end

	def store_location
		session[:return_to] = request.url
	end

	def redirect_to_smartly(path)
		unless session[:return_to].nil?
			redirect_to session[:return_to]
		else
			redirect_to path
		end
	end

	# before filter for signin calls this
	def signed_in_user
		unless signed_in?
			store_location
			flash[:notice] = "Please Sign In"
			redirect_to signin_url
		end
	end

	def sign_out
		cookies.delete(:session_token)
		current_user = nil
		session[:return_to] = nil
	end

end
