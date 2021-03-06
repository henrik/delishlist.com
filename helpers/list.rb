helpers do
  
  ADDRESS_RE = %r{(?:\A|\r?\n\r?\n)Address: *[\r\n]+(.+?)(?:\r?\n\r?\n|\z)}m
  
  def sort_link
    return unless @list.more_than_one_rating?

    rating = @list.sorted_by_rating? ? 'rating' : link_to('rating', list_path(:by => nil))
    recent = @list.sorted_by_recent? ? 'recent' : link_to('recent', list_path(:by => List::ORDER_RECENT))
    
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
        unless note.empty?
          haml_tag(:h3, "Note")
          haml_tag(:div, nl2br(h(note)), :id => "note")
        end
        
        if address
          haml_tag(:h3, "Address")
          haml_tag(:address, h(address).strip.gsub("\n", "<br>"))
        end
      end
      
    end
  end

end
