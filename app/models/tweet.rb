class Tweet # PORO

  # for a tweet ID, will request the embedding object
  def self.oembed(id)
    resource = RestClient::Resource.new "https://api.twitter.com/1/statuses/oembed.json?id=#{id}"
    response = resource.get
    parsed_response = JSON.parse(response)
  end

  # takes an array of hashtags and returns applicable tweets
  def self.search_by_tags(hashtags, user, user_tags_only = false)
    # Users the "twitter" gem from https://github.com/sferik/twitter

    return [] if user_tags_only && user.authorizations.find_by_provider("twitter").nil?

    Twitter.configure do |config|
      config.consumer_key = "QVim65jLuVeoo7phUAP0AQ"
      config.consumer_secret = "5tMM645CWOmHwZKcf8xbIVCbRhPHYzMAkmhwvwX7s"
      if user.authorizations.find_by_provider("twitter").nil?
        config.oauth_token = "313316959-gic7hb72LjHqQ1fmE914c1hUuuN51pA3RBzyOA7c"
        config.oauth_token_secret = "vPhMqtGJOww0QmKrulUjSCpB2yoyxQGWfMQGcTI2knM"
      else
        config.oauth_token = user.authorizations.find_by_provider("twitter").token
        config.oauth_token_secret = user.authorizations.find_by_provider("twitter").secret
      end
    end

    search_term = "#" + hashtags.join(" OR #")

    if user_tags_only
      twitter_handle = user.authorizations.find_by_provider("twitter").account_name
      search_term += " from:#{twitter_handle}" 
    end

    puts "\n\n SEARCH_TERM: !#{search_term}! \n\n"
    begin
      results = Twitter.search(search_term).results
    rescue Twitter::Error::ClientError => e
      puts "ERROR: End of File Reached"
      return []
    end

    tweets = results.map do |tweet|

      { :media_type   => "tweet",
        :id           => tweet.attrs[:id],
        :created_at   => tweet.attrs[:created_at],
        :timestamp    => Time.parse(tweet.attrs[:created_at]).to_i,
        :text         => tweet.attrs[:text],
        :source       => tweet.attrs[:source],
        :username     => tweet.attrs[:user][:screen_name],
        :user_image   => tweet.attrs[:user][:profile_image_url],
        :geo          => tweet.attrs[:geo],
        :coordinates  => tweet.attrs[:coordinates],
        :source       => tweet.attrs[:source] }
        #:url          => tweet.attrs[:entities][:urls][0][:display_url] }
    end
    puts "\n\n TWEETS: #{tweets.inspect}! \n\n"
    tweets
  end

end