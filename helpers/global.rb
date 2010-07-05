helpers do

  def h(text)
    Rack::Utils.escape_html(text)
  end
  
  def link_to(text, url, opts={})
    klass = opts[:class] && %{ class="#{h opts[:class]}"}
    title = opts[:title] && %{ title="#{h opts[:title]}"}
    %{<a href="#{h url}"#{klass}#{title}>#{text}</a>}
  end

  def partial(name)
    haml(:"_#{name}", :layout => false)
  end
  
  def image_tag(path, opts={})
    alt = opts[:alt] && %{ alt="#{h opts[:alt]}"}
    %{<img src="/images/#{path}"#{alt}>}
  end
  
  # Wrap text in fancy Unicode quotes
  def q(text)
    %{“%s”} % text
  end

end
