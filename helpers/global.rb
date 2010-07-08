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
    path = path.include?("://") ? path : "/images/#{path}"
    %{<img src="#{path}" alt="#{h opts[:alt]}">}
  end
  
  # Wrap text in fancy Unicode quotes
  def q(text)
    %{“%s”} % text
  end
  
  def nl2br(text)
    text = text.to_s.dup
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</p>\n\n<p>")           # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    "<p>#{text}</p>"
  end

end
