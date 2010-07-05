helpers do
  
  attr_writer :title, :header

  def title
    format = @title || "%s"
    h(format % "Delishlist")
  end
  
  def header
    if @user
      link_to(h(@user.name), list_path(@user))
    else
      h(@header)
    end
  end
  
end
