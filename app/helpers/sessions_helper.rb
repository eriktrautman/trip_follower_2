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
		@current_user
	end

	def current_user=(user)
		@current_user = user
	end

end
