require 'shared_link'

describe SharedLink do
  describe '#new' do
    it 'does not explode on circular redirects' do
      stub_request(:get, 'example.com')
        .to_return(:status => 302,
                   :headers => {'Location' => 'http://foo.com/bar'})

      stub_request(:get, 'foo.com/bar')
        .to_return(:status => 302,
                   :headers => {'Location' => 'http://example.com/'})

      link = SharedLink.new('http://example.com/')
      expect(link.uri.to_s).to eql('http://example.com/')
      expect(link.title).to be_nil
    end

    it 'follows redirects' do
      stub_request(:get, 'example.com')
        .to_return(:status => 302,
                   :headers => {'Location' => 'http://foo.com/bar'})

      stub_request(:get, 'foo.com/bar')
        .to_return(:body => '<title>hi</title>')

      link = SharedLink.new('http://example.com/')
      expect(link.uri.to_s).to eql('http://foo.com/bar')
      expect(link.title).to eql('hi')
    end

    it 'works with non-HTML pages' do
      stub_request(:get, 'example.com')
        .to_return(:body => 'hi')

      link = SharedLink.new('http://example.com/')
      expect(link.uri.host).to eql('example.com')
      expect(link.uri.to_s).to eql('http://example.com/')
      expect(link.title).to be_nil
      expect(link.description).to be_nil
    end

    it 'works with pages that have a <title>' do
      stub_request(:get, 'example.com')
        .to_return(:body => '<title>hi</title>')

      link = SharedLink.new('http://example.com/')
      expect(link.title).to eql('hi')
    end

    it 'works with pages that have a <meta name="description">' do
      stub_request(:get, 'example.com')
        .to_return(:body => '<meta name="description" content="blah">')

      link = SharedLink.new('http://example.com/')
      expect(link.description).to eql("blah")
    end
  end
end
