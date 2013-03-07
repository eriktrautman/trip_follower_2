class Tumblr # PORO

  def self.search_by_tags(hashtags, user, user_tags_only = false)
    # Doesn't use any gems at all

    return [] if user_tags_only && user.authorizations.find_by_provider("tumblr").nil?

    hashtag = hashtags.first # TEMPORARY TESTING MEASURE.. WAIT, NO, tUmblr doesn't
    #support multiple hashtag searches.  Crap.
    api_key = "aX3GtjNdUNH8Q8ZUBoZ1HbrTBYh9acrIdbWd99qtu1M8RXx2NU"

    # Will use OAuth signed request unless user hasn't enabled Tumblr
    # which results in a generic api key being used (and potentially overwhelmed!)
    if user_tags_only
      access_token = Tumblr.prepare_access_token(user)
      user_account = user.authorizations.find_by_provider("tumblr").account_name
      url = "http://api.tumblr.com/v2/blog/#{user_account}.tumblr.com/posts?api_key=#{api_key}&tag=#{hashtag}"
      response = access_token.get(url)
    else
      url = "http://api.tumblr.com/v2/tagged?tag=#{hashtag}&api_key=#{api_key}"
      resource = RestClient::Resource.new(url)
      response = resource.get
    end

    puts "\n\n URL: #{url}!"

    parsed_response = JSON.parse(response.body)
    if user_tags_only
      raw_tumbles = parsed_response["response"]["posts"]
    else
      raw_tumbles = parsed_response["response"]
    end
    puts "\n\n TUMBLES RAAAAAAW: #{raw_tumbles.inspect} \n\n"
    tumbles = raw_tumbles.map do |post|
      tumble = {  :media_type   => "tumble",
                  :blog_name    => post["blog_name"],
                  :post_id      => post["id"],
                  :url          => post["post_url"],
                  :type         => post["type"],
                  :timestamp    => post["timestamp"].to_i,
                  :date         => post["date"],
                  :photos       => post["photos"]
                 }
      case post["type"]
      when "text"
        tumble[:title]  = post["title"]
        tumble[:body]   = post["body"]
      when "photo"
        tumble[:caption]= post["caption"],
        tumble[:image_url] = post["photos"][0]["original_size"]["url"]
      when "video"
        tumble[:caption]= post["caption"]
        tumble[:html5]  = post["html5_capable"]
        tumble[:player] = post["player"]
      else
      end
      tumble
    end
    puts "\n\n TUMBLES: #{tumbles.inspect}! \n\n"
    tumbles
  end

  def self.prepare_access_token(user)
    user_auth = user.authorizations.where(provider: "tumblr").first
    token = user_auth.token
    secret = user_auth.secret

    consumer = OAuth::Consumer.new( "aX3GtjNdUNH8Q8ZUBoZ1HbrTBYh9acrIdbWd99qtu1M8RXx2NU", "pwJVt25o5QlcrV2Wq7TSpaCJhgzmMOR2hzYFpkwosWmcW1jYpE", site: "http://www.tumblr.com/")
    token_hash = {oauth_token: token, oauth_token_secret: secret}
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    puts "ACCESS TOKEN: #{access_token.inspect}"
    access_token
  end

end