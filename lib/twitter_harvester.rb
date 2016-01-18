require 'twitter'

class Twitter::Tweet
  require_relative './util'

  def harvest
    links = uris.select do |uri|
      !Util.quoted_tweet_url? uri.expanded_url
    end
    quoted_status? ? links.concat(quoted_status.harvest) : links
  end
end

class TwitterHarvester < Twitter::REST::Client
  def harvest_home_timeline(count)
    home_timeline({count: count}).map {|tweet| tweet.harvest}.flatten
  end
end
