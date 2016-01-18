require_relative 'lib/twitter_harvester'

harvester = TwitterHarvester.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

harvester.harvest_home_timeline(20).each do |uri|
  print "#{uri.expanded_url}\n"
end
