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

  # At least on img dimension has to be greater than min
  def self.find_first_min_img_src(html, min)
    parsed_html = Nokogiri::HTML(html)
    images = parsed_html.css('img')

    images.each do |img|
        if img['src']
          w = img['width'].to_i
          h = img['height'].to_i

          if (w >= min || h >= min)
            return img['src']
          end
        end
    end

    return nil
  end

  def self.html_to_text(html)
    Nokogiri::HTML(html).text
  end
end
