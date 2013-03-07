class Flickr #< PORO

  def self.search_by_tags(hashtags, user, user_tags_only = false)
    # Doesn't use any gems at all!

    return [] if user_tags_only && user.authorizations.find_by_provider("flickr").nil?

    tags = hashtags.join("%2C")
    api_key = "812710f0d4bf1d785110c5d431c52852"
    per_page = 10
    page = 1
    base_url = "http://api.flickr.com/services/rest/"
    options = [   "?method=flickr.photos.search",
                  "api_key=#{api_key}",
                  "tags=#{tags}",
                  "format=json",
                  "nojsoncallback=1",
                  "per_page=#{per_page}",
                  "page=#{page}" ]

    # Use OAuth if trip is "whitelisted posters only", else basic API key auth
    if user_tags_only
      access_token = Flickr.prepare_access_token(user)
      options += ["user_id=me"]
      url = base_url + options.join("&")
      response = access_token.get(url)
    else
      url = base_url + options.join("&")
      resource = RestClient::Resource.new(url)
      response = resource.get
    end

    puts "\n\n Flickr (after grabbing batch) URL: #{url}!"

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

      # Re-query the API to get the photo's timestamp (for sorting). Annoying.
      options = [ "?method=flickr.photos.getInfo",
                  "api_key=#{api_key}",
                  "format=json",
                  "nojsoncallback=1",
                  "photo_id=#{flickr[:photo_id]}" ]
      url = base_url + options.join("&")
      if user_tags_only
        options += ["user_id=me"]
        response = access_token.get(url)
      else
        resource = RestClient::Resource.new(url)
        response = resource.get
      end
      parsed_response = JSON.parse(response.body)

      flickr[:username] = parsed_response["photo"]["owner"]["username"]
      flickr[:timestamp] = (parsed_response["photo"]["dates"]["taken"]).to_time.to_i

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

  # returns a raw response object which varies based on the method used
  def self.api_call(options, access_token = false)
    # useful??
  end

end