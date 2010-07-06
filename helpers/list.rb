helpers do
  
  ADDRESS_RE = %r{(?:\A|\n\n)Address:\n+(.+?)(?:\n\n|\z)}m
  
  
  def sort_link
    return unless @list.more_than_one_rating?

    rating = @list.sorted_by_rating? ? 'rating' : link_to('rating', list_path(:by => nil))
    recent = @list.sorted_by_recent? ? 'recent' : link_to('recent', list_path(:by => 'recent'))
    
    text = "Sort by: #{rating} &bull; #{recent}"
    
    capture_haml do
      haml_tag(:p, text, :id => "sorting")
    end
  end
  
  
  def format_list_description(description)
    if description
      
      address = description[ADDRESS_RE, 1]
      note    = description.sub(ADDRESS_RE, '').strip
      
      capture_haml do
        haml_tag(:h3, "Note")
        haml_tag(:p, h(note), :id => "note")
        
        if address
          haml_tag(:h3, "Address")
          haml_tag(:address, h(address).strip.gsub("\n", "<br>"))
        end
      end
      
    end
  end
  

  def first_of_its_rating?(item)
    @last_rating && @last_rating != item.rating
  end
  
  def first_of_its_year?(item)
    @last_date && @last_date.year != item.added.year
  end
  
  def first_in_new_section?(item)
    @list.sorted_by_recent? ? first_of_its_year?(item) : first_of_its_rating?(item)
  end


  def title_attributes(item)
    klass = first_in_new_section?(item) ? 'first-in-new-section' : nil
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
  
  
  # Date
  
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
  
  
  # Rating
  
  def rating_link(item)
    tag_link(item.rating_slug)
  end
  

  # Tags

  def tags_for(item)
    item.tags.sort.map { |tag| tag_link(tag) }.join(", ")
  end
  
  # TODO: Sorting.
  def tag_link(tag)    
    if @tags.any? && !@tags.include?(tag)
      tags = [tag] + @tags
      tags_string = tags.join('+')
      
      link = link_to(fancy_tags(tags), list_path(:tags => tags_string), :title => "See only items tagged #{q tags_string}")
      drilldown = %{<span class="drilldown">%s</span>} % link
    else
      drilldown = ""
    end
    
    tag_link = link_to(fancy_tag(tag), list_path(:tags => tag), :title => "See only items tagged #{q tag}")
    %{<span class="tag-with-drilldown">%s%s</span>} % [tag_link, drilldown]
  end
  
  def fancy_tag(tag, options = {})
    options = { :html => true }.merge(options)

    star = windows? ? "*" : "★"
    if options[:html]
      blank_star = star
    else
      blank_star = windows? ? "_" : "☆"
    end
    
    case tag
    when Item::RATING_RE, "_"
      rating = tag=="_" ? 0 : tag.length
      stars  = star * rating
      blanks = blank_star * (@list.highest_rating - rating)
      pattern = options[:html] ? %{<span class="rating"><strong>%s</strong>%s</span>} : %{%s%s}
      pattern % [stars, blanks]
    else
      options[:html] ? h(tag) : tag
    end
  end
  
  def fancy_tags(tags, options = {})
    tags.map {|tag| fancy_tag(tag, options) }.join("+")
  end
  
  # Windows doesn't seem to include any default font that handles Unicode stars.
  def windows?
    request.user_agent.include?("Windows")
  end
  private :windows?

end
