class Tweet # PORO

  # for a tweet ID, will request the embedding object
  def self.oembed(id)
    resource = RestClient::Resource.new "https://api.twitter.com/1/statuses/oembed.json?id=#{id}"
    response = resource.get
    parsed_response = JSON.parse(response)
  end


  # takes an array of hashtags and returns applicable tweets
  def self.search_by_tags(hashtags)
    # Users the "twitter" gem from https://github.com/sferik/twitter

    Twitter.configure do |config|
      config.consumer_key = "QVim65jLuVeoo7phUAP0AQ"
      config.consumer_secret = "5tMM645CWOmHwZKcf8xbIVCbRhPHYzMAkmhwvwX7s"
      config.oauth_token = "313316959-gic7hb72LjHqQ1fmE914c1hUuuN51pA3RBzyOA7c"
      config.oauth_token_secret = "vPhMqtGJOww0QmKrulUjSCpB2yoyxQGWfMQGcTI2knM"
    end

    search_term = "#" + hashtags.join(" OR #")

    tweets = Twitter.search(search_term).results.map do |tweet|

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
  end

end