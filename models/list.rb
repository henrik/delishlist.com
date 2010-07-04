class List

  attr_reader :user, :description, :items
  
  def initialize(username)
    delicious = Delicious.new(username, "wishlist")
    description, items = delicious.tag_description_and_items
    
    @user = User.new(username)
    @description = description
    @items = items.map { |hash| Item.new(hash) }.reject { |i| i.exclude? }
  end
  
end
