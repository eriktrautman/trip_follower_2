class Feed

  def self.from_tags(tags, user)
  	puts "\n\n FEED TAGS: #{tags.inspect} \n\n"
  	return [] unless tags.size > 0
  	instagrams = []# Instagram.search_by_tags(tags, user, false)
    flickrs = Flickr.search_by_tags(tags,user,false)
    tweets = Tweet.search_by_tags(tags, user, false)
    tumbles = Tumblr.search_by_tags(tags, user, false)

  	tumbles + instagrams + tweets + flickrs
  end

  def self.from_tags_by_user(tags, user)

  	puts "\n\n FEED TAGS: #{tags.inspect} \n\n"
  	return [] unless tags.size > 0
  	instagrams = []# Instagram.search_by_tags(tags, user, false)
    flickrs = Flickr.search_by_tags(tags,user,true)
    tweets = Tweet.search_by_tags(tags, user, true)
    tumbles = Tumblr.search_by_tags(tags, user, true)

  	tumbles + instagrams + tweets + flickrs

  end

  def self.sort_feed(feed)
		feed.sort_by { |item| -item[:timestamp] }
  end

end