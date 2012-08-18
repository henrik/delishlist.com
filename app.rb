require "#{File.dirname(__FILE__)}/setup.rb"
set :app_file, __FILE__  # Unbreak Bundler.

get "/" do
  haml :index, :layout => :layout
end

get "/stylesheets/:stylesheet.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :"sass/#{params[:stylesheet]}"
end


get '/:user/set_image' do
  setup_image
  @image = Image.new(:image_url => Image.image_url_for_item_url_and_user(@url, @user))
  haml :set_image, :layout => :'layout/set_image'
end

post '/:user/set_image' do
  setup_image

  @image = Image.new(:item_url => @url, :image_url => params[:image_url], :username => @user.name, :ip => request.ip)
  if @image.save
    haml :set_image_done, :layout => :'layout/set_image'
  else
    haml :set_image, :layout => :'layout/set_image'
  end
end

def setup_image
  @user = User.new(params[:user])
  @title, @url, @id = params.values_at(:title, :url, :id)
  @previous_image_urls = Image.suggestions_for_url(@url)
end


get '/scrape_images' do
  content_type 'application/json', :charset => 'utf-8'
  ImageScraper.new(params[:url]).to_json
end

post "/expire_cache" do
  ObjectCache.new(settings.cache).expire(params[:user])
  "OK"
end


get "/:user" do
  get_list
end

get "/:user/:tags" do
  get_list
end

def get_list
  username = params[:user]

  @list = ObjectCache.new(settings.cache).fetch(username, settings.cache_seconds) {
    List.new(username)
  }

  @tags = params[:tags].to_s.split(/[+ ]/)
  @list.filter_to_tags(@tags)

  if params[:by] == List::ORDER_RECENT
    @list.sort_by_recent
  else
    @list.sort_by_rating
  end

  @user = @list.user
  haml :list
rescue Delicious::NoSuchUser, Pinboard::NoSuchUser
  haml :no_such_user
end
