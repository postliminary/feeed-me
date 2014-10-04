class HtmlHelper
  # At least on img dimension has to be greater than min if specified
  def self.find_first_img_src(html, min = nil)
    parsed_html = Nokogiri::HTML(html)
    images = parsed_html.css('img')

    images.each do |img|
        if img['src']
          w = img['width'].to_i
          h = img['height'].to_i

          if (min == nil || (w >= min || h >= min))
            return img['src']
          end
        end
    end

    return nil
  end

  def self.html_to_text(html)
    Nokogiri::HTML(html).text
  end

  def self.sanitize(html)
    Sanitize.fragment(html, Sanitize::Config::RELAXED)
  end
end
