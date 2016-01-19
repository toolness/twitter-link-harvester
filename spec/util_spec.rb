require 'util'
require 'addressable/uri'

describe Util do
  describe '#squish' do
    it 'returns nil when given nil' do
      expect(Util.squish nil).to be_nil
    end

    it 'returns nil instead of empty string' do
      expect(Util.squish '').to be_nil
    end

    it 'squishes whitespace' do
      expect(Util.squish " hi\nthere").to eql('hi there')
    end
  end

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
