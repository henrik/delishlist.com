class Image < ActiveRecord::Base
  
  def self.image_url_for_item_and_user(item, user)
    image = latest_image_for_url_and_user(item.url, user)
    image ? image.image_url : URLImager.image_url(item.url)
  end
  
private

  def self.latest_image_for_url_and_user(url, user)
    order = send(:sanitize_sql_array, ['(username = ?) DESC, id DESC', user.name])
    Image.first(:select => :image_url, :conditions => { :item_url => url }, :order => order)
  end

end
