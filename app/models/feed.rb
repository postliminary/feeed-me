class Feed < ActiveRecord::Base
  has_many :entries, dependent: :destroy

  validates :title, presence: true
  validates :url, presence: true, uniqueness: true
  validate :valid_feed_url, on: :create

  scope :alphabetical, -> { order('title') }

  def valid_feed_url
    feed_url = FeedHelper.find_feed_url(self.url)

    if feed_url
      self.url = feed_url
    else
      errors.add(:url, 'is invalid or does not refer to a feed')
    end

    if Feed.exists?(:url => feed_url)
      errors.add(:url, 'already added')
    end
  end

  def update_from_remote()
    raw = FeedHelper.fetch(self.url)

    self.title = raw.title

    self.save

    raw.entries.each do |entry|
      # Skip if entry already exists
      new_entry_id = Digest::SHA1.hexdigest(self.id.to_s +
                                                entry.entry_id.to_s + entry.url.to_s)

      next if Entry.exists?(:entry_id => new_entry_id)

      new_entry = Entry.create(
          :entry_id => new_entry_id,
          :feed_id => self.id,
          :title => entry.title,
          :url => entry.url,
          :author => entry.author,
          :content => HtmlHelper.sanitize(entry.content),
          :summary => HtmlHelper.sanitize(entry.summary),
          :summary_text => HtmlHelper.html_to_text(entry.summary || entry.content),
          :published => entry.published,
          :updated => entry.updated,
          # Need to figure out what to do with categories array
          # Serialize or separate entity?
          #:categories => entry.categories,
          :image_url => entry.image
      )

      new_entry.add_image_from_remote

    end
  end

  handle_asynchronously :update_from_remote
end
