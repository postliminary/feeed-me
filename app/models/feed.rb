class Feed < ActiveRecord::Base
  require 'uri'
  require 'feedbag'
  require 'feedjira'

  validates :title, presence: true
  validates :url, presence: true, uniqueness: true

  has_many :entries, dependent: :destroy

  def fetch
    Feedjira::Feed.add_common_feed_element 'image', :as => :image
    feed = Feedjira::Feed.fetch_and_parse self.url

    self.title = feed.title

    Entry.bulk_create(feed.entries, self)

    self.save
  end

  def self.create_from_url(any_url)
    feed = Feed.new
    feed.title = any_url
    feed.url = Feedbag.find(any_url).first

    # Try to save
    if feed.url != nil && feed.save
      # First fetch
      feed.fetch
    else
      feed.errors.add(:url, 'is invalid or does not refer to a feed')
    end

    return feed
  end

  def self.fetch_all

  end
end
