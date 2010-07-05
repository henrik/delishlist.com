helpers do

  def h(text)
    Rack::Utils.escape_html(text)
  end
  
  def link_to(text, url, opts={})
    klass = opts[:class] && %{ class="#{opts[:class]}"}
    %{<a href="#{h url}"#{klass}>#{text}</a>}
  end

  def partial(name)
    haml(:"_#{name}", :layout => false)
  end
  
  def image_tag(x, y)
    ""
  end

end
