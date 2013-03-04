class Feed

  def self.from_tags(tags, user)
    puts "\n\n FEED TAGS: #{tags.inspect} \n\n"
    return [] unless tags.size > 0
    instagrams = Instagram.search_by_tags(tags, user)
    tweets = Tweet.search_by_tags(tags, user)
    tumbles = Tumblr.search_by_tags(tags, user)

    media = tumbles + instagrams + tweets
    puts "\n\n MEDIA: #{media.inspect}"
    media.sort_by { |item| -item[:timestamp]}
  end

end