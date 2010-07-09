require "rubygems"
require "sinatra"

require "haml"
set :haml, :format => :html5, :attr_wrapper => %{"}

cache_minutes = 15  # Since we can't reference settings from each other.
set :cache_minutes, cache_minutes
set :cache_seconds, cache_minutes * 60

if ENV['RACK_ENV'] == 'production'
  set :cache_root, "#{File.dirname(__FILE__)}/../shared/cache"
else
  set :cache_root, "/tmp/delishlist"
end

Dir["{helpers,models,lib}/**/*.rb"].each { |f| require f }


get "/" do
  haml :index, :layout => :layout
end

get "/stylesheets/:stylesheet.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :"sass/#{params[:stylesheet]}"
end

post "/expire_cache" do
  ObjectCache.new(params[:user], :root => settings.cache_root).expire
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

  @list = ObjectCache.get_or_set(username, :ttl => settings.cache_seconds, :root => settings.cache_root) {
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

rescue Delicious::NoSuchUser

  haml :no_such_user

end
