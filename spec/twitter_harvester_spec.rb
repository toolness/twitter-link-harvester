require 'twitter_harvester'

API_URL = 'https://api.twitter.com/1.1'

API_HEADERS = {
  'Accept'=>'application/json',
  'Accept-Encoding'=>/.*/,
  'Authorization'=>/OAuth .*/,
  'User-Agent'=>/TwitterRubyGem\/.+/
}

describe TwitterHarvester do
  describe '#harvest_home_timeline' do
    it 'should work' do
      stub_request(:get, API_URL + '/statuses/home_timeline.json?count=10')
        .with(:headers => API_HEADERS)
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => File.new('spec/home_timeline_response.json'))

      twitter = TwitterHarvester.new do |config|
        config.consumer_key = 'a'
        config.consumer_secret = 'b'
        config.access_token = 'c'
        config.access_token_secret = 'd'
      end

      urls = twitter.harvest_home_timeline(10).map {|uri| uri.to_s}
      expect(urls).to eql([
        "http://blogs.ischool.berkeley.edu/i290-abdt-s12/"
      ])
    end
  end
end
