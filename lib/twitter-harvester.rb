require 'twitter'

class TwitterHarvester < Twitter::REST::Client
  require_relative './util'

  def harvest_tweet(tweet)
    uris = tweet.uris.select do |uri|
      !Util.quoted_tweet_url? uri.expanded_url
    end
    if tweet.quoted_status?
      uris.concat harvest_tweet(tweet.quoted_status)
    end
    return uris
  end

  def harvest_home_timeline(count)
    home_timeline({count: count}).map {|tweet| harvest_tweet(tweet)}
      .flatten
  end
end
