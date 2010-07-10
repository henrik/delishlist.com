class Image < ActiveRecord::Base
  
  def self.image_url_for_item_and_user(item, user)
    image_url_for_item_url_and_user(item.url, user)
  end
  
  def self.image_url_for_item_url_and_user(url, user)
    image = latest_image_for_url_and_user(url, user)
    image ? image.image_url : URLImager.image_url(url)
  end
  
  def self.suggestions_for_url(url)
    urls = Image.all(:select => :image_url, :conditions => { :item_url => url }, :order => 'id DESC').map { |i| i.image_url }
    urls << URLImager.image_url(url)
    urls.reject! { |u| u.blank? }
    urls.uniq!
    urls
  end
  
private

  def self.latest_image_for_url_and_user(url, user)
    order = send(:sanitize_sql_array, ['(username = ?) DESC, id DESC', user.name])
    Image.first(:select => :image_url, :conditions => { :item_url => url }, :order => order)
  end

end
