require 'nokogiri'

class HtmlUtil
  def self.find_first_img_src(html)
    parsed_html = Nokogiri::HTML(html)
    img = parsed_html.css('img')

    if img.first && img.first['src']
      return img.first['src']
    end

    return nil
  end
end
