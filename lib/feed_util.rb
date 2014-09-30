require "open-uri"
require "open_uri_redirections"
require 'feedbag'
require 'feedjira'

class FeedUtil
  def self.find_feed_url(any_url)
    Feedbag.find(any_url).first
  end

  def self.parse(url)
    Feedjira::Feed.fetch_and_parse(url)
  end
end