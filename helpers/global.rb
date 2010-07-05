helpers do

  def h(text)
    Rack::Utils.escape_html(text)
  end
  
  def link_to(text, url)
    %{<a href="#{h url}">#{text}</a>}
  end

  def partial(name)
    haml(:"_#{name}", :layout => false)
  end
  
  def image_tag(x, y)
    ""
  end

end
