require 'twitter'

TWEET_COUNT = 20
STATUS_URL_RE = /^https?:\/\/twitter\.com\/.+\/status\/([0-9]+)$/

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

def harvest_tweet(client, tweet)
  tweet.uris.each do |uri|
    print "#{uri.expanded_url}\n"
    match = STATUS_URL_RE.match(uri.expanded_url)
    if match
      print "Following #{match[1]}\n"
      harvest_tweet(client, client.status(match[1].to_i))
    end
  end
end

def harvest_urls(client)
  client.home_timeline({count: TWEET_COUNT}).each do |tweet|
    harvest_tweet(client, tweet)
  end
end

harvest_urls client
