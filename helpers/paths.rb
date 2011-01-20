helpers do
  
  def list_path(opts={})
    parts = []
    parts << "/#{opts[:user] || @user.url_name}"
    
    tags = opts.has_key?(:tags) ? opts[:tags] : params[:tags]
    parts << "/#{tags}" if tags
    
    by = opts.has_key?(:by) ? opts[:by] : params[:by]
    parts << "?by=#{by}" if by
    parts.join
  end

  def edit_url(item)
    url = Rack::Utils.escape(item.url)
    if @user.pinboard?
      "http://pinboard.in/add?showtags=yes&url=#{url}"
    else
      "http://delicious.com/save?url=#{url}&noui=1"
    end
  end
  
end
