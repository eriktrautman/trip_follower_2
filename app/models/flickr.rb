class Flickr #< PORO

  def self.search_by_tags(hashtags, user, user_tags_only = false)
    # Doesn't use any gems at all!

    return [] if user_tags_only && user.authorizations.find_by_provider("flickr").nil?

    tags = hashtags.join("%2C")
    api_key = "812710f0d4bf1d785110c5d431c52852"


    if user_tags_only
      access_token = Flickr.prepare_access_token(user)
      url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{api_key}&tags=#{tags}&format=json&nojsoncallback=1&user_id=me"
      response = access_token.get(url)
    else
      url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{api_key}&tags=#{tags}&format=json&nojsoncallback=1"
      resource = RestClient::Resource.new(url)
      response = resource.get
    end

    puts "\n\n URL: #{url}!"

    parsed_response = JSON.parse(response.body)
    raw_flickrs = parsed_response["photos"]["photo"]
    flickrs = raw_flickrs.map do |photo|
      flickr = {  :media_type     => "flickr",
                  :photo_id       => photo["id"],
                  :owner          => photo["owner"],
                  :secret         => photo["secret"],
                  :server         => photo["server"],
                  :farm           => photo["farm"],
                  :title          => photo["title"],
                  :timestamp      => 0
                 }
      flickr[:url] = "http://farm#{photo['farm']}.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.jpg"
      flickr
    end
    puts "\n\n FLICKRS: #{flickrs.inspect}! \n\n"
    flickrs
  end

  def self.prepare_access_token(user)
    user_auth = user.authorizations.where(provider: "flickr").first
    token = user_auth.token
    secret = user_auth.secret

    consumer = OAuth::Consumer.new( "812710f0d4bf1d785110c5d431c52852", "853727b0318f027c", site: "http://www.flickr.com/")
    token_hash = {oauth_token: token, oauth_token_secret: secret}
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    access_token
  end

end