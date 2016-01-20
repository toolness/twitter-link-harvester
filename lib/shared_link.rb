class SharedLink
  require 'addressable/uri'
  require 'nokogiri'
  require 'httpclient'
  require 'httpclient/util'

  require_relative './util'

  attr_reader :title, :description, :uri

  MAX_REDIRECTS = 10

  def initialize(uri)
    if not uri.is_a? Addressable::URI
      uri = Addressable::URI.parse(uri)
    end

    client = HTTPClient.new
    res = client.get(uri)
    redirect_count = 0

    # Note that httpclient does have the ability to follow redirects, but
    # it doesn't seem to have the ability to tell us the URL of the final
    # endpoint, which is something we want. So we'll do this ourselves.
    while res.redirect? and redirect_count < MAX_REDIRECTS
      new_uri = HTTPClient::Util::urify(res.header['location'][0])
      new_uri = uri + new_uri if new_uri.relative?
      uri = new_uri
      res = client.get(uri)
      redirect_count += 1
    end

    html_doc = Nokogiri::HTML(res.body)
    title = html_doc.at_css('title')
    description = html_doc.at_css('meta[name=description]')

    @uri = uri
    @title = title ? Util.squish(title.content) : nil
    @description = description ? Util.squish(description['content']) : nil
  end

  # This fake class can be used for testing.
  class Fake
    attr_reader :title, :description, :uri

    def initialize(uri:, title: nil, description: nil)
      @uri = Addressable::URI.parse(uri.to_s)
      @title = title
      @description = description
    end
  end
end
