class Feed < ActiveRecord::Base
  has_many :entries, dependent: :destroy

  validates :title, presence: true
  validate :valid_feed

  scope :alphabetical, -> { order('title') }

  def valid_feed
    feed_url = FeedUtil.find_feed_url(self.url)

    if feed_url
      self.url = feed_url
    else
      errors.add(:url, 'is invalid or does not refer to a feed')
    end

    if Feed.exists?(:url => feed_url)
      errors.add(:url, 'already added')
    end
  end

  def self.create_from_url(any_url)
    feed = Feed.new
    feed.title = UrlUtil.normalize(any_url)
    feed.url = any_url

    # Try to save
    if feed.save
      # First fetch
      feed.fetch
    end

    return feed
  end

  def fetch
    f = FeedUtil.parse(self.url)

    self.title = UrlUtil.normalize(f.title)
    self.site_url = f.url

    Entry.add_to_feed(f.entries, self)
  end

  def self.fetch_all
    Feed.all.each { |feed| feed.fetch }
  end

  handle_asynchronously :fetch
end
