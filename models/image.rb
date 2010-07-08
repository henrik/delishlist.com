class Image
  
  def self.build(item, user)
    URLImager.image_url(item.url)
  end
  
end
