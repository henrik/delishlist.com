require "set"

class Item
  
  NOT_AN_ITEM_PARTS = %w[del.ishli.st delishlist.com gifttagging.com boxedup.com metawishlist.com wishlist.com 
                         wishlistr.com wishlistr.se henrik.nyh.se/2008/02/delishlist]
  NOT_AN_ITEM_RE = /\b#{Regexp.union(*NOT_AN_ITEM_PARTS)}\b/
  
  RATING_RE = /^\*+$/
  
  attr_reader :key, :title, :url, :description, :rating, :tags, :added
  
  def initialize(hash)
    @key         = hash[:key]
    @title       = TitleImprover.improve_title(hash[:title])
    @url         = hash[:url]
    @description = hash[:description]
    @added       = hash[:added]
    
    set_tags_and_rating(hash[:tags])
  end
  
  def exclude?
    @url.downcase.match(NOT_AN_ITEM_RE) != nil
  end
  
  
  def rating
    @rating || 0
  end
  
  def rating_slug
    rating.nonzero? ? "*" * rating : "_"
  end
  
  def tags_and_rating
    tags + Set[rating_slug]
  end
  
  def anchor
    [Slugalizer.slugalize(title), unchanging_anchor].join("__")
  end
  
  # Short but likely unique identifier, as part of URL anchors (fragments).
  def unchanging_anchor
    self.key[0,6]
  end
  
private

  def set_tags_and_rating(tags_and_ratings)
    tags_and_ratings = tags_and_ratings.reject { |t| t.downcase == "wishlist" }
    ratings, tags = tags_and_ratings.partition { |tag| tag.match(RATING_RE) }
    
    @tags = Set.new(tags)
    @rating = ratings.empty? ? nil : ratings.max_by { |r| r.length }.length
  end

end
