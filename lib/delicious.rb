# The Delicious API is limited to a maximum of 100 items if you don't authenticate each user,
# so we're forced to scrape.

require "net/http"
require "open-uri"
require "date"
require "cgi"

require "rubygems"
require "hpricot"

class Delicious
  class NoSuchUser < StandardError; end
  
  def initialize(username, tags)
    @username = username
    @tags = tags
  end
  
  def tag_description_and_items
    @page = 1
    get_page(@page)
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
    # Seems Delicious removed these.
    # TODO: Support some other means of getting a description?
  end
  
  def get_page(page)
    @page = page
    file = open("http://delicious.com/#{@username}/#{@tags}?page=#{@page}")
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

      link_node = li.at("h4 a")
      date_node = li.at(".date")
      desc_node = li.at(".notes span")

      url = CGI.unescape(link_node[:href].sub("/redirect?url=", ""))

      last_good_date = Date.today
      if date_node
        raw_date = date_node.inner_text
        # There are some broken dates on new Delicious.
        begin
          added = Date.parse(raw_date)
          last_good_date = added
        rescue ArgumentError => e
          if e.message == "invalid date"
            added = last_good_date
          else
            raise
          end
        end
      end

      if desc_node
        desc = desc_node.inner_text.sub(/\A"(.*)"\z/, '\1')
      end

      {
        :key         => li[:id].split('-')[1],
        :title       => link_node[:title],
        :url         => url,
        :description => desc,
        :added       => added,
        :tags        => li.search(".tag-chain-tag a").map { |x| x.inner_text }
      }
    end
  end
  
  def previous_page_number
    # New Delicious incorrectly uses .next for previous...
    prev_number = @doc.search("a.pn.next").map { |x| x[:href][/[?&]page=(\d+)/, 1].to_i }.find { |num| num > @page }
    prev_number
  end
  
end

if __FILE__ == $0
  
  del = Delicious.new("johanni", "wishlist")
  p del.tag_description_and_items
  #p del.tag_description_and_items.last.map{|x| x[:added]}
  
end
