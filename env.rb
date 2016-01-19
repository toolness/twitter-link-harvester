class Env
  require 'pony'

  require_relative 'lib/twitter_harvester'

  def initialize(env = ENV)
    @env = env
  end

  def create_harvester
    TwitterHarvester.new do |config|
      config.consumer_key = @env['TWITTER_CONSUMER_KEY']
      config.consumer_secret = @env['TWITTER_CONSUMER_SECRET']
      config.access_token = @env['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = @env['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def configure_pony
    Pony.options = {
      :to => @env['EMAIL_TO'],
      :from => @env['EMAIL_FROM'] || @env['SMTP_USERNAME'],
      :via => :smtp,
      :via_options => {
        :address => @env['SMTP_HOSTNAME'],
        :port => @env['SMTP_PORT'],
        :user_name => @env['SMTP_USERNAME'],
        :password => @env['SMTP_PASSWORD'],
        :enable_starttls_auto => !@env['SMTP_ENABLE_STARTTLS_AUTO'].nil?,
        :authentication => @env['SMTP_AUTHENTICATION'] &&
                           @env['SMTP_AUTHENTICATION'].to_sym
      }
    }
    Pony
  end
end
