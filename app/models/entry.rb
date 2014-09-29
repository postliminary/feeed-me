require "open-uri"
require "open_uri_redirections"

class Entry < ActiveRecord::Base
  belongs_to :feed
  has_attached_file :image, :styles => {:medium => '300x300>', :thumb => '100x100>'}, :default_url => '/images/:style/missing.png'

  validates :entry_id, presence: true, uniqueness: true
  validates :feed_id, presence: true
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  scope :recent, -> { order('published desc') }

  def self.bulk_create(entries, feed)
    entries.each do |entry|
      # Skip if entry already exists
      break if exists? :entry_id => entry.entry_id

      new_entry = create(
          :entry_id => entry.entry_id,
          :feed_id => feed.id,
          :title => entry.title,
          :url => entry.url,
          :author => entry.author,
          :content => entry.content,
          :summary => entry.summary,
          :published => entry.published,
          :updated => entry.updated,
          :categories => entry.categories,
      )

      # Try and add image
      if entry.image.present?
        new_entry.image = open(entry.image, :allow_redirections => :safe)
      else
        content = Nokogiri::HTML(entry.content)
        img = content.css('img')

        if img.first && img.first['src']
          new_entry.image = open(img.first['src'], :allow_redirections => :safe)
        end
      end

      new_entry.save
    end
  end
end
