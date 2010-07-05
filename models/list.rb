class List

  attr_reader :user, :description, :items
  
  def initialize(username)
    delicious = Delicious.new(username, "wishlist")
    description, items = delicious.tag_description_and_items
    
    @user = User.new(username)
    @description = description
    @items = items.map { |hash| Item.new(hash) }.reject { |i| i.exclude? }
    sort_by_rating
  end
  
  def sort_by_rating
    @items = items.sort_by { |i| [i.rating, i.added] }.reverse
  end
  
  def highest_rating
    @highest_rating ||= items.max_by { |i| i.rating }.rating
  end
  
  def filter_to_tags(tags)
    tags = Set.new(tags)
    @items = items.select { |i| tags.subset?(i.tags_and_rating) }
  end
  
end
