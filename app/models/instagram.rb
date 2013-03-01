class Instagram  # PORO!

  # CLIENT ID b50084b45ed94392a160fa31b0e7a488
  # CLIENT SECRET 88ce5753c5024ac19f8038baf2538847
  # WEBSITE URL http://127.0.0.1/
  # REDIRECT URI  http://127.0.0.1/authorization/instagram

  def self.recent_photos
    resource = RestClient::Resource.new 'https://api.instagram.com/v1/media/popular?client_id=b50084b45ed94392a160fa31b0e7a488'
    photos = resource.get
  end

  def self.photos_by_tag(hashtag)
    resource = RestClient::Resource.new "https://api.instagram.com/v1/tags/#{hashtag}/media/recent?client_id=b50084b45ed94392a160fa31b0e7a488"
    response = resource.get
    parsed_response = JSON.parse(response)
    photoUrls = parsed_response["data"].map do |photo_obj|
      { :media_type     => "instagram",
        :username       => photo_obj["user"]["username"],
        :timestamp      => photo_obj["created_time"].to_i,
        :link           => photo_obj["link"],
        :thumbnail      => photo_obj["images"]["thumbnail"],
        :low_res        => photo_obj["images"]["low_resolution"],
        :standard_res   => photo_obj["images"]["standard_resolution"] }
    end
  end

end