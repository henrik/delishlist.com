helpers do

  def source_site_link
    @user.pinboard? ? pinboard_link : delicious_link
  end

  def pinboard_link
    link_to("Pinboard", "http://pinboard.in/")
  end

  def delicious_link
    link_to("Delicious", "http://delicious.com/")
  end
  
  def head(&block)
    @more_head = capture_haml(&block)
  end

end
