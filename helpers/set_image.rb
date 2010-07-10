helpers do
  
  def set_image_url_link(url)
    link_to(h(truncate(url, 50)), url, :target => "_blank", :id => "item_url")
  end

  def set_image_giigle_link(query)
    text = q(%{<span id="item_name" title="#{h query}">#{h truncate(query, 40)}</span>})
    url = "http://images.google.com/images?q=#{Rack::Utils.escape(query)}"
    link_to(text, url, :target => "_blank")
  end

  
end