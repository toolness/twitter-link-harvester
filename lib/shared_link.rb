class SharedLink
  require 'addressable/uri'
  require 'nokogiri'
  require 'httpclient'

  attr_reader :title, :description, :uri

  MAX_REDIRECTS = 10

  def initialize(uri)
    if not uri.is_a? Addressable::URI
      uri = Addressable::URI.parse(uri)
    end

    client = HTTPClient.new
    res = client.get(uri)
    redirect_count = 0

    while res.redirect? and redirect_count < MAX_REDIRECTS
      new_uri = client.default_redirect_uri_callback(uri, res)
      uri = new_uri
      res = client.get(uri)
      redirect_count += 1
    end

    html_doc = Nokogiri::HTML(res.body)
    title = html_doc.at_css('title')
    description = html_doc.at_css('meta[name=description]')

    @uri = uri
    @title = title ? title.content : nil
    @description = description ? description['content'] : nil
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
