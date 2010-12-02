# The Delicious API is limited to a maximum of 100 items if you don't authenticate each user,
# so we're forced to scrape.

require "net/http"
require "open-uri"
require "date"

require "rubygems"
require "hpricot"

class Delicious
  class NoSuchUser < StandardError; end
  
  def initialize(username, tags)
    @username = username
    @tags = tags
  end
  
  def tag_description_and_items
    get_page(1)
    parse_tag_description
    
    results = parse_items
    while number = previous_page_number do
      get_page(number)
      results += parse_items
    end
    [@tag_description, results]
  rescue OpenURI::HTTPError
    raise NoSuchUser
  end
  
private
  
  def parse_tag_description
    get_page(1) unless @doc
    desc = @doc.at("#tagdescdisp")
    @tag_description = desc && desc.inner_text.strip
  end
  
  def get_page(page)
    file = open("http://delicious.com/#{@username}/#{@tags}?setcount=100&page=#{page}")
    response_code = file.status.first
    
    if response_code == "200"
      @doc = Hpricot(file.read)
    else
      raise NoSuchUser, @username
    end
  end
    
  def parse_items
    added = nil  # Items from same day only have date on the first one.
    @doc.search("li.post").map do |li|

      link_node = li.at("h4 a.taggedlink")
      date_node = li.at(".dateGroup")
      desc_node = li.at(".description")
      if date_node
        raw_date = date_node[:title].strip.sub(/ (\d\d)$/, ' 20\1')
        added = Date.parse(raw_date)
      end
      
      {
        :key         => li[:id].split('-')[1],
        :title       => link_node.inner_text,
        :url         => link_node[:href],
        :description => desc_node && desc_node.inner_text.strip,
        :added       => added,
        :tags        => li.search(".tag").map { |x| x.inner_text }
      }
    end
  end
  
  def previous_page_number
    if prev_link = @doc.at("a.pn.next")
      prev_link[:href][/\?page=(\d+)/, 1]
    else
      nil
    end
  end
  
end

if __FILE__ == $0
  
  del = Delicious.new("johanni", "wishlist")
  p del.tag_description_and_items
  
end
