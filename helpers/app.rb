helpers do

  def delicious_link(text = "Delicious", path = "")
    link_to(text, URI.join("http://delicious.com/", path).to_s)
  end
  
  def head(&block)
    @more_head = capture_haml(&block)
  end

end
