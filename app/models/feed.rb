class Feed

  def self.from_tags(tags)
    return [] unless tags.size > 0
    instagrams = Instagram.search_by_tags(tags)
    tweets = Tweet.search_by_tags(tags)
    tumbles = Tumblr.search_by_tags(tags)

    media = tumbles + instagrams + tweets
    media.sort_by { |item| -item[:timestamp]}
  end

end