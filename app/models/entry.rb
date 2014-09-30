class Entry < ActiveRecord::Base
  belongs_to :feed
  has_attached_file :image, :styles => {:medium => '300x300>', :thumb => '100x100>'}, :default_url => '/images/:style/missing.png'

  validates :entry_id, presence: true, uniqueness: true
  validates :feed_id, presence: true
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  scope :recent, -> { order('published desc') }

  self.per_page = 20

  def self.add_to_feed(entries, feed)
    entries.each do |entry|
      # Skip if entry already exists
      break if exists?(:entry_id => entry.entry_id, :feed_id => feed.id)

      new_entry = create(
          :entry_id => entry.entry_id,
          :feed_id => feed.id,
          :title => entry.title,
          :url => entry.url,
          :author => entry.author,
          :content => entry.content,
          :summary => entry.summary,
          :summary_text => HtmlUtil.html_to_text(entry.summary ? entry.summary : entry.content),
          :published => entry.published,
          :updated => entry.updated,
          :categories => entry.categories,
      )

      image_url = entry.image ? entry.image : new_entry.find_image_url()

      if image_url
        new_entry.image = open(image_url, :allow_redirections => :safe)
        new_entry.save
      end
    end
  end

  def find_image_url
    # Try and find an image to use
    if self.summary
      summary_img = HtmlUtil.find_first_img_src(self.summary)
      return summary_img if summary_img
    end

    if self.content
      content_img = HtmlUtil.find_first_img_src(self.content)
      return content_img if content_img
    end

    return nil
  end
end
