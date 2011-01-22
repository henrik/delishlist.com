# The Pinboard API is limited, forcing us to scrape.

require "net/http"
require "open-uri"
require "date"

require "rubygems"
require "hpricot"
require "json"

class Pinboard
  class NoSuchUser < StandardError; end
  
  def initialize(username, tags)
    @username = username
    @tags = tags
  end
  
  def tag_description_and_items
    parse_tag_description

    get_page(nil)
    results = parse_items
    while before = previous_page_before do
      get_page(before)
      results += parse_items
    end
    [@tag_description, results]
  rescue OpenURI::HTTPError
    raise NoSuchUser
  end

private

  def parse_tag_description
    raw = open("http://feeds.pinboard.in/json/v1/u:#{@username}/t:delishlist/t:me").read
    data = JSON.parse(raw).first
    @tag_description = data && data["n"]
  rescue OpenURI::HTTPError
    @tag_description = nil
  end
  
  def get_page(before)
    url = "http://pinboard.in/u:#{@username}/t:#{@tags}/#{"before:#{before}" if before}"
    file = open(url)
    @doc = Hpricot(file.read)
    # Should check for redirect to /not_found/, but open-uri in Ruby 1.8 is too limited.
    if @doc.at("#main_column").inner_html.strip == "Page not found."
      raise(NoSuchUser, @username)
    end
  end
    
  def parse_items
    bookmarks = @doc.to_s.scan(/bmarks\[\d+\] = (\{.*?\});/).map { |captures| JSON.parse(captures.first) }
    bookmarks.map do |bookmark|
      added = Date.parse(bookmark["created"])
      {
        :key         => bookmark["url_id"],
        :title       => bookmark["title"],
        :url         => bookmark["url"],
        :description => bookmark["description"],
        :added       => added,
        :tags        => bookmark["tags"]
      }
    end
  end
  
  def previous_page_before
    if prev_link = @doc.at(".next_prev")
      prev_link[:href][/before:(\d+)/, 1]
    else
      nil
    end
  end
  
end

if __FILE__ == $0
  
  del = Pinboard.new("henrik", "wishlist")
  p del.tag_description_and_items
  
end
