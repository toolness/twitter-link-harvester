require 'twitter'

require_relative 'lib/util'

TWEET_COUNT = 20

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

def harvest_tweet(client, tweet)
  tweet.uris.each do |uri|
    if not Util.quoted_tweet_url?(uri.expanded_url)
      print "#{uri.expanded_url}\n"
    end
  end
  if tweet.quoted_status?
    harvest_tweet(client, tweet.quoted_status)
  end
end

def harvest_urls(client)
  client.home_timeline({count: TWEET_COUNT}).each do |tweet|
    harvest_tweet(client, tweet)
  end
end

harvest_urls client
