class List

  attr_reader :user, :description, :items
  
  def initialize(username)
    delicious = Delicious.new(username, "wishlist")
    description, items = delicious.tag_description_and_items
    
    @user = User.new(username)
    @description = description
    @items = items.map { |hash| Item.new(hash) }.reject { |i| i.exclude? }
  end
  
  
  def empty?
    @items.empty?
  end


  def more_than_one_rating?
    highest_rating != lowest_rating
  end

  def lowest_rating
    @lowest_rating ||=  items.any? ? items.min_by { |i| i.rating }.rating : nil
  end

  def highest_rating
    @highest_rating ||= items.any? ? items.max_by { |i| i.rating }.rating : nil
  end
  
  
  def sort_by_rating
    @items = items.sort_by { |i| [i.rating, i.added] }.reverse
    @order = :rating
  end
  
  def sort_by_recent
    @items = items.sort_by { |i| [i.added, i.rating] }.reverse
    @order = :recent
  end
  
  def sorted_by_rating?
    @order == :rating
  end
  
  def sorted_by_recent?
    @order == :recent
  end


  def filter_to_tags(tags)
    return if tags.empty?
    tags = Set.new(tags)
    @items = items.select { |i| tags.subset?(i.tags_and_rating) }
  end
  
end
