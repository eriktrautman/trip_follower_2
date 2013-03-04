class Tumblr # PORO

  def self.search_by_tags(hashtags, user)
    # Doesn't use any gems at all

    hashtag = hashtags.first # TEMPORARY TESTING MEASURE.. WAIT, NO, tUmblr doesn't
    #support multiple hashtag searches.  Crap.

    access_token = Tumblr.prepare_access_token(user)
    api_key = "aX3GtjNdUNH8Q8ZUBoZ1HbrTBYh9acrIdbWd99qtu1M8RXx2NU"
    response = access_token.get("http://api.tumblr.com/v2/tagged?tag=#{hashtag}&api_key=#{api_key}")

    parsed_response = JSON.parse(response.body)
    tumbles = parsed_response["response"].map do |post|
      tumble = {  :media_type   => "tumble",
                  :blog_name    => post["blog_name"],
                  :post_id      => post["id"],
                  :url          => post["post_url"],
                  :type         => post["type"],
                  :timestamp    => post["timestamp"].to_i,
                  :date         => post["date"]
                 }
      case post["type"]
      when "text"
        tumble[:title]  = post["title"]
        tumble[:body]   = post["body"]
      when "photo"
        tumble[:caption]= post["caption"]
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