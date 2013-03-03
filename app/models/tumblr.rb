class Tumblr # PORO

    def self.search_by_tags(hashtags, user)
      # Doesn't use any gems at all yet

      hashtag = hashtags.first # TEMPORARY TESTING MEASURE
      #consumer_key = user.authorizations.where(provider: "tumblr").first.token
      #https://github.com/appacademy/ruby-curriculum/blob/master/the-web/oauth.md
      #https://github.com/pelle/oauth/blob/master/lib/oauth/tokens/access_token.rb
      

      consumer_key = "aX3GtjNdUNH8Q8ZUBoZ1HbrTBYh9acrIdbWd99qtu1M8RXx2NU"
      resource = RestClient::Resource.new "http://api.tumblr.com/v2/tagged?tag=#{hashtag}&api_key=#{consumer_key}"
      response = resource.get
      parsed_response = JSON.parse(response)
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
      # puts tumbles
      tumbles
    end

end