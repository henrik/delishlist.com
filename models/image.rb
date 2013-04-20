class Image < ActiveRecord::Base
  validates_format_of :image_url, :with => %r{\Ahttps?://}, :allow_blank => true
  validates_presence_of :item_url, :username, :ip

  before_save :protect_from_spam

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

  def protect_from_spam
    # Got thousands and thousands of these.
    # Check for new spam URLs:
    #   heroku run console
    #   require "./app"
    #   Image.having("COUNT(*) > 10").count(group: "item_url")
    #
    # And maybe do:
    #
    #   Image.where(item_url: "http://fit-pc2.com/").delete_all
    if image_url.to_s.include?("fit-pc2.com") || item_url.to_s.include?("fit-pc2.com")
      raise "Smells like spam!"
    end
  end

  def self.latest_image_for_url_and_user(url, user)
    order = send(:sanitize_sql_array, ['(username = ?) DESC, id DESC', user.name])
    Image.first(:select => :image_url, :conditions => { :item_url => url }, :order => order)
  end
end
