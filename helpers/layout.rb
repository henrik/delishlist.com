helpers do
  
  attr_writer :header

  def title
    h(@page_title) || "Delishlist"
  end
  
  def title=(title)
    @page_title = title
  end
  
  def header
    if @user
      link_to(h(@user.name), list_path(:tags => nil))
    else
      h(@header)
    end
  end
  
end
