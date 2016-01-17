class SharedLink
  require 'nokogiri'
  require 'httpclient'

  attr_reader :title, :desc, :uri

  MAX_REDIRECTS = 10

  def initialize(uri)
    client = HTTPClient.new
    res = client.get(uri)
    redirect_count = 0

    while res.redirect? and redirect_count < MAX_REDIRECTS
      new_uri = client.default_redirect_uri_callback(uri, res)
      uri = new_uri
      res = client.get(uri)
    end

    html_doc = Nokogiri::HTML(res.body)
    title = html_doc.at_css('title')
    desc = html_doc.at_css('meta[name=description]')

    @uri = uri
    @title = title ? title.content : nil
    @desc = desc ? desc['content'] : nil
  end
end
