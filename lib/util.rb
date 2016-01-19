module Util
  STATUS_URL_RE = /^https?:\/\/twitter\.com\/.+\/status\/([0-9]+)$/

  def Util.quoted_tweet_url?(url)
    (url.to_s =~ STATUS_URL_RE) != nil
  end

  def Util.squish(str)
    return str if str.nil?
    str = str.strip.split.join(' ')
    str == '' ? nil : str
  end
end
