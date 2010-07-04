helpers do

  def delicious_link(text = "Delicious", path = "")
    link_to(text, URI.join("http://delicious.com/", path).to_s)
  end

end
