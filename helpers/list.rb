helpers do
  
  def order_by_rating?
    true  # TODO: Implement.
  end
  
  def first_of_its_rating?(item)
    @last_rating && @last_rating != item.rating
  end

  def title_attributes(item)
    klass = (order_by_rating? && first_of_its_rating?(item)) ? 'first-in-rating-block' : nil
    {
      :id    => item.anchor,
      :class => klass
    }
  end
  
  def referralize(url)
    Amazon::Referralizer.referralize(url, "delishlist-20")
  end
  
  def format_description(description)
    DescriptionFormatter.new(description).format
  end

end
