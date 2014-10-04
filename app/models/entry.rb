class Entry < ActiveRecord::Base
  belongs_to :feed
  has_attached_file :image, :styles => {:medium => '300x300>', :thumb => '100x100>'}, :default_url => '/images/:style/missing.png'

  validates :entry_id, presence: true, uniqueness: true
  validates :feed_id, presence: true
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  scope :recent, -> { order('published desc') }

  def self.last_entry_at
    (Time.now.utc - Entry.maximum(:updated_at)).floor * 1000
  end

  def find_image_url
    # Try and find an image to use
    if self.summary
      summary_img = HtmlHelper.find_first_img_src(self.summary, 100)
      return summary_img if summary_img
    end

    if self.content
      content_img = HtmlHelper.find_first_img_src(self.content, 100)
      return content_img if content_img
    end

    return nil
  end

  def add_image_from_remote
    self.image_url = self.image_url || find_image_url

    if self.image_url
      self.image = open(self.image_url, :allow_redirections => :safe)
      self.save
    end
  end

  handle_asynchronously :add_image_from_remote
end
