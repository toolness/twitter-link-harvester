require 'json'

require 'twitter_harvester'

API_URL = 'https://api.twitter.com/1.1'

API_HEADERS = {
  'Accept'=>'application/json',
  'Accept-Encoding'=>/.*/,
  'Authorization'=>/OAuth .*/,
  'User-Agent'=>/TwitterRubyGem\/.+/
}

class FakeTweet
  def initialize(id, urls, quoted_tweet = nil)
    @id = id
    @urls = urls
    @quoted_tweet = quoted_tweet
  end

  def to_json(options = nil)
    result = {
      'id': @id,
      'entities': {
        'urls': @urls.map do |url|
          {'expanded_url': url}
        end
      },
      quoted_status: @quoted_tweet
    }

    return result.to_json
  end
end

def stub_home_timeline(tweets)
  stub_request(:get, API_URL + '/statuses/home_timeline.json?count=10')
    .with(:headers => API_HEADERS)
    .to_return(:headers => {'Content-Type' => 'application/json'},
               :body => tweets.to_json)
end

def harvester()
  TwitterHarvester.new do |config|
    config.consumer_key = 'a'
    config.consumer_secret = 'b'
    config.access_token = 'c'
    config.access_token_secret = 'd'
  end
end

describe TwitterHarvester do
  describe '#harvest_home_timeline' do
    it 'ignores tweets without URLs' do
      stub_home_timeline([
        FakeTweet.new(1, []),
        FakeTweet.new(2, ['http://bop'])
      ])

      expect(harvester().harvest_home_timeline(10).map {|uri| uri.to_s})
        .to eql(['http://bop'])
    end

    it 'ignores quoted tweet URLs' do
      stub_home_timeline([
        FakeTweet.new(1, ['https://twitter.com/foo/status/1']),
        FakeTweet.new(2, ['http://bop'])
      ])

      expect(harvester().harvest_home_timeline(10).map {|uri| uri.to_s})
        .to eql(['http://bop'])
    end

    it 'includes URLs in quoted tweets' do
      stub_home_timeline([
        FakeTweet.new(1, [], FakeTweet.new(3, ['http://blah'])),
        FakeTweet.new(2, ['http://bop'])
      ])

      expect(harvester().harvest_home_timeline(10).map {|uri| uri.to_s})
        .to eql(['http://blah', 'http://bop'])
    end
  end
end
