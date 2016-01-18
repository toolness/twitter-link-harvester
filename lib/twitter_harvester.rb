require 'twitter'

class Twitter::Tweet
  require_relative './util'

  def harvest
    links = uris.map {|entity| entity.expanded_url}.select do |uri|
      !Util.quoted_tweet_url? uri
    end
    quoted_status? ? links.concat(quoted_status.harvest) : links
  end
end

class TwitterHarvester < Twitter::REST::Client
  def harvest_home_timeline(count)
    home_timeline({count: count}).map {|tweet| tweet.harvest}.flatten
  end
end
