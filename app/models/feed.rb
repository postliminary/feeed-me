class Feed < ActiveRecord::Base
  require "feedbag"
  require "uri"

  validates :title, presence:true
  validates :url, presence:true

  def self.find_feed_url(any_url)
    feed_url = Feedbag.find(any_url).first
    feed_url = Uri.parse(feed_url).normalize unless feed_url == nil
    return feed_url
  end
end
