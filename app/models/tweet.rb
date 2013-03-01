class Tweet # PORO

  # for a tweet ID, will request the embedding object
  def self.oembed(id)
    resource = RestClient::Resource.new "https://api.twitter.com/1/statuses/oembed.json?id=#{id}"
    response = resource.get
    parsed_response = JSON.parse(response)
  end

end