class Feed < ActiveRecord::Base
  require 'uri'
  require 'feedbag'
  require 'feedjira'

  validates :title, presence:true
  validates :url, presence:true

  def fetch
    feed = Feedjira::Feed.fetch_and_parse(self.url)
    self.title = feed.title
  end

  def self.from_url(any_url)
    feed = Feed.new
    feed.title = any_url
    feed.url = any_url

    feed_url = Feedbag.find(any_url).first

    if feed_url != nil
      feed.url = feed_url
      # First fetch
      feed.fetch
    else
      feed.errors.add(:url, 'is does not refer to a feed')
    end

    return feed
  end

  def self.fetch_all

  end
end
