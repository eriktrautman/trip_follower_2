module ApplicationHelper

	def full_title(page_title)
		base_title = "Trip Follower"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
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

end
