class UrlUtil
  def self.normalize(url_string)
    norm_url = url_string.sub(/^.*:?\/\//i, '')
    norm_url = url_string.sub(/\/$/i, '')
    return norm_url
  end
end