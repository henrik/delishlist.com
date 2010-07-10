require "open-uri"
require "timeout"

require "rubygems"
require "rack"
require "hpricot"
require "json"

class ImageScraper
  TIMEOUT = 8  # seconds
  BLOCK_LIST = %w[pixel.gif header.gif /pixel_trans.gif /blank.gif /trans_1x1.gif]
  BLOCK_RE = Regexp.new(BLOCK_LIST.map { |x| Regexp.escape(x) }.join('|'), Regexp::IGNORECASE)
  
  def initialize(url_or_keyword)
    store_url_or_keyword(url_or_keyword)
    scrape
  end
  
  def to_json
    @urls.to_json
  end

protected

  def store_url_or_keyword(url_or_keyword)
    if url_or_keyword.match(%r{\Ahttps?://}i)
      @url = url_or_keyword
    else
      @keyword = url_or_keyword
    end    
  end
  
  def url
    @url ? @url : "http://images.google.com/images?q=#{Rack::Utils.escape(@keyword)}"
  end
  
  def keyword?
    @keyword != nil
  end
  
  def scrape
    doc = Timeout.timeout(TIMEOUT) { Hpricot(open(url)) }

    if keyword?
      urls = doc.to_s.scan(/imgurl\\x3d(.+?)\\x26/).flatten
    else
      urls = doc.search("img").map {|img| URI.join(url, img["src"]).to_s rescue nil }
    end
    
    @urls = urls.reject {|url| url.nil? || url.empty? || url.match(BLOCK_RE) }.uniq
  rescue Exception => e
    puts "Image scraper error! #{e}"
    @urls = []
  end

end

if $0 == __FILE__
  p ImageScraper.new("pug").to_json
  p ImageScraper.new("http://en.wikipedia.org/wiki/Main_Page").to_json
end
