class FeedHelper
  def self.find_feed_url(any_url)
    Feedbag.find(any_url).first
  end

  def self.fetch(url)
    Feedjira::Feed.fetch_and_parse(url)
  end
end