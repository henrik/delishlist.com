# Attempt to get an image URL from a product URL.

class URLImager

  # Not a secret. Please get your own, though:
  # http://www.librarything.com/blogs/librarything/2008/08/a-million-free-covers-from-librarything/
  LIBRARYTHING_DEVKEY = "04570df8a6206e239efefe1fe5c7fc0b"

  TRANSFORMATIONS = [
  
    # Amazon: ISBN-10 or ASIN. Will return an 1x1 blank GIF on failure.
    [%r{https?://(?:.+\.)?(?:amazon\.|amzn\.com\b).+?\b([0-9A-Z]{10})\b},  lambda { |isbn| "http://images.amazon.com/images/P/#{isbn}.01.THUMBZZZ.jpg" }],
      
    [%r{http://store\.apple\..*?/product/(MB\d+)},         lambda { |id| "http://storeimages.apple.com/1413/as-images.apple.com/is/image/AppleInc/#{id}" }],
    [%r{http://www\.bokus\.com/b(?:ok)?/(\d+)},            lambda { |isbn| "http://image.bokus.com/images2/#{isbn}_large" }],
    [%r{http://www\.adlibris\.com/.*?\?isbn=(\d+)},        lambda { |isbn| "http://www.adlibris.com/se/covers/M/#{isbn[0,1]}/#{isbn[1..2]}/#{isbn}.jpg" }],
    [%r{http://www\.cafepress\..*?(\d{5,})},               lambda { |id| "http://images8.cpcache.com/product/#{id}v2_350x350.jpg" }],
    [%r{http://www\.worldofboardgames\.com/.*?ID=(\d+)},   lambda { |id| "http://www.worldofboardgames.com/bgimages/#{id}-1-Medium.jpg" }],
    [%r{^http://www\.uncommongoods\.com/.*?itemId=(\d+)},  lambda { |id| "http://www.uncommongoods.com/images/product/#{id}_sm.jpg" }],
    [%r{^http://www\.threadless\.com/product/(\d+)},       lambda { |id| "http://media.threadless.com/product/#{id}/minizoom.jpg" }],
    [%r{^http://www\.webhallen\.com/.*?/(\d{5,})},         lambda { |id| "http://images.webhallen.com/product/#{id}" }],
    [%r{^http://www.play.com/.+?/(\d{5,})\b},              lambda { |id| "http://images.play.com/covers/#{id}s.jpg" }],
    [%r{^http://(?:www\.)?pragprog\.com/titles/(\w+)},     lambda { |id| "http://www.pragprog.com/images/covers/190x228/#{id}.jpg" }],
    [%r{^http://www\.prisjakt\.nu/produkt\.php\?p=(\d+)},  lambda { |id| "http://www.prisjakt.nu/bilder/bild.php?p=#{id}" }],

    # ISBN catchall.
    [%r{[&?]isbn=([0-9A-Z]{10,13})}i,  lambda { |isbn| "http://covers.librarything.com/devkey/#{LIBRARYTHING_DEVKEY}/medium/isbn/#{isbn}" }]
    
  ]
  
  def self.image_url(url)
    TRANSFORMATIONS.each do |re, lambda|
      return lambda.call($1) if url.match(re)
    end
    nil
  end
  
end

if $0 == __FILE__
  puts URLImager.image_url("http://www.amazon.com/Ton-Beau-Marot-Praise-Language/dp/0465086454")
end
