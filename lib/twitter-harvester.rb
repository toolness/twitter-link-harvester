require 'twitter'

class TwitterHarvester < Twitter::REST::Client
  require_relative './util'

  def harvest_tweet(tweet)
    tweet.uris.each do |uri|
      yield uri unless Util.quoted_tweet_url?(uri.expanded_url)
    end
    if tweet.quoted_status?
      harvest_tweet(tweet.quoted_status) {|uri| yield uri}
    end
  end

  def harvest_home_timeline(count)
    home_timeline({count: count}).each do |tweet|
      harvest_tweet(tweet) {|uri| yield uri}
    end
  end
end
