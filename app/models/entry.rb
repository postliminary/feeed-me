class Entry < ActiveRecord::Base
  validates :entry_id, presence: true, uniqueness: true
  validates :feed_id, presence: true

  belongs_to :feed

  scope :recent, order("published desc")

  def self.bulk_create(entries, feed)
    entries.each do |entry|
      # Skip if entry already exists
      break if exists? :entry_id => entry.entry_id

      create(
          :entry_id => entry.entry_id,
          :feed_id => feed.id,
          :title => entry.title,
          :url => entry.url,
          :author => entry.author,
          :content => entry.content,
          :summary => entry.summary,
          :published => entry.published,
          :updated => entry.updated,
          :categories => entry.categories
      )
    end
  end
end
