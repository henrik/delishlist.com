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
  
  def date_attributes(item)
    days_ago = (Date.today - item.added).to_i
    klass = days_ago < 7 ? "days-ago-#{days_ago}" : nil
    {
      :title => "Added #{item.added}",
      :class => klass
    }
  end

  def humanize_date(date)
    now = Time.now.utc
    today = Date.new(now.year, now.month, now.day)

    format_string =
      if date == today
        "Today"
      elsif date == today - 1  # Yesterday.
        "Yesterday"
      elsif date > today - 7  # This week.
        "%A"  # e.g. "Monday"
      else
        year = date.year < Date.today.year ? ", %Y" : ""
        date_format = "%b %d#{year}"  # e.g. "Jul 5, 2010"
      end
    date.strftime(format_string).
      sub(/\b0/, "")  # Remove leading zeros.
  end

end
