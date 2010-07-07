require "rubygems"
require "sinatra"

require "haml"
set :haml, :format => :html5, :attr_wrapper => %{"}

CACHE_TTL = 5 * 60   # 5 minutes
CACHE_ROOT = "/tmp/cache"

Dir["{helpers,models,lib}/**/*.rb"].each { |f| require f }

get "/" do
  haml :index, :layout => :layout
end

get "/stylesheets/:stylesheet.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :"sass/#{params[:stylesheet]}"
end

post "/expire_cache" do
  ObjectCache.new(params[:user], :root => CACHE_ROOT).expire
  "OK"
end

get "/:username" do
  get_list
end

get "/:username/:tags" do
  get_list
end

def get_list

  username = params[:username]

  @list = ObjectCache.get_or_set(username, :ttl => CACHE_TTL, :root => CACHE_ROOT) {
    List.new(username)
  }
  
  @tags = params[:tags].to_s.split(/[+ ]/)
  @list.filter_to_tags(@tags)
  
  if params[:by] == 'recent'
    @list.sort_by_recent
  else
    @list.sort_by_rating
  end
  
  @user = @list.user
  haml :list

rescue Delicious::NoSuchUser

  haml :no_such_user

end
