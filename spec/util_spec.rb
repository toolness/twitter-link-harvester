require 'util'
require 'addressable/uri'

describe Util do
  describe '#quoted_tweet_url?' do
    it 'rejects non-URLs' do
      expect(Util.quoted_tweet_url? 'blah').to eql(false)
    end

    it 'rejects non-twitter URLs' do
      expect(Util.quoted_tweet_url? 'http://foo.com/').to eql(false)
    end

    it 'accepts twitter status URLs' do
      expect(Util.quoted_tweet_url?('https://twitter.com/t/status/1'))
        .to eql(true)
    end

    it 'coerces arg to string' do
      url = Addressable::URI.parse('https://twitter.com/t/status/1')
      expect(Util.quoted_tweet_url?(url)).to eql(true)
    end
  end
end
