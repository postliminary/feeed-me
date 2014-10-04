class UrlHelper
  def self.normalize(url_string)
    url_string.sub(/^.*:?\/\//, '').sub(/\/$/, '')
  end
end