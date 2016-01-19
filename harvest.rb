require_relative 'lib/twitter_harvester'
require_relative 'env'

harvester = Env.create_harvester()

harvester.harvest_home_timeline(20).each do |uri|
  print "#{uri}\n"
end
