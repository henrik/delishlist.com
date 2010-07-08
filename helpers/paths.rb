helpers do
  
  def list_path(opts={})
    parts = []
    parts << "/#{opts[:user] || @user}"
    
    tags = opts.has_key?(:tags) ? opts[:tags] : params[:tags]
    parts << "/#{tags}" if tags
    
    by = opts.has_key?(:by) ? opts[:by] : params[:by]
    parts << "?by=#{by}" if by
    parts.join
  end

  def delicious_edit_url(item)
    url = Rack::Utils.escape(item.url)
    "http://delicious.com/save?url=#{url}"
  end
  
end
