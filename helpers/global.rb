helpers do

  def h(text)
    Rack::Utils.escape_html(text)
  end
  
  def tag(name, attributes={})
    "<#{name}#{attribute_string(attributes)}>"
  end
  
  def content_tag(name, content, attributes={})
    "<#{name}#{attribute_string(attributes)}>#{content}</#{name}>"
  end
  
  def attribute_string(attributes)
    attributes.empty? ? "" : " #{attributes.map {|k,v| %{#{k}="#{h v}"} }.join(' ')}"
  end
  private :attribute_string
  
  def link_to(text, url, opts={})
    opts[:href] = url
    content_tag(:a, text, opts)
  end

  def partial(name)
    haml(:"_#{name}", :layout => false)
  end
  
  def image_tag(path, opts={})
    src = path.include?("://") ? path : "/images/#{path}"  
    alt = opts[:alt] || ""
    tag(:img, opts.merge(:src => src, :alt => alt))
  end
  
  # Wrap text in fancy Unicode quotes
  def q(text)
    %{“%s”} % text
  end
  
  def truncate(text, length = 30, truncate_string = "…")
    if text
      l = length - truncate_string.length
      (text.length > length ? text[0...l] + truncate_string : text).to_s
    end
  end
  
  def nl2br(text)
    text = text.to_s.dup
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</p>\n\n<p>")           # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    "<p>#{text}</p>"
  end

end
