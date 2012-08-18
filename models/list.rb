class List

  ORDER_RECENT = 'recent'

  attr_reader :user, :description, :items

  def initialize(username)
    @user = User.new(username)

    parser = @user.parser
    description, items = parser.tag_description_and_items

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
    @lowest_rating ||=  items.any? ? items.map { |i| i.rating }.min : 0
  end

  def highest_rating
    @highest_rating ||= items.any? ? items.map { |i| i.rating }.max : 0
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
