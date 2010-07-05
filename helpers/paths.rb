helpers do
  
  def list_path(user, tag_string=nil)
    "/#{user.name}" + 
    (tag_string ? "/#{tag_string}" : "")
  end
  
end
