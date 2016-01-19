module Env
  require 'pony'

  require_relative 'lib/twitter_harvester'

  def self.create_harvester(env = ENV)
    TwitterHarvester.new do |config|
      config.consumer_key = env['TWITTER_CONSUMER_KEY']
      config.consumer_secret = env['TWITTER_CONSUMER_SECRET']
      config.access_token = env['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = env['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def self.configure_pony(env = ENV)
    Pony.options = {
      :to => env['EMAIL_TO'],
      :from => env['EMAIL_FROM'] || env['SMTP_USERNAME'],
      :via => :smtp,
      :via_options => {
        :address => env['SMTP_HOSTNAME'],
        :port => env['SMTP_PORT'],
        :user_name => env['SMTP_USERNAME'],
        :password => env['SMTP_PASSWORD'],
        :enable_starttls_auto => !ENV['SMTP_ENABLE_STARTTLS_AUTO'].nil?,
        :authentication => ENV['SMTP_AUTHENTICATION'] &&
                           ENV['SMTP_AUTHENTICATION'].to_sym
      }
    }
    Pony
  end
end
