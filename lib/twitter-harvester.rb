require 'twitter'

class TwitterHarvester < Twitter::REST::Client
  require_relative './util'

  def harvest_tweet(tweet)
    tweet.uris.each do |uri|
      if not Util.quoted_tweet_url?(uri.expanded_url)
        print "#{uri.expanded_url}\n"
      end
    end
    if tweet.quoted_status?
      harvest_tweet(tweet.quoted_status)
    end
  end

  def harvest_home_timeline(count)
    home_timeline({count: count}).each do |tweet|
      harvest_tweet(tweet)
    end
  end
end