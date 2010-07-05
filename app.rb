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

get "/:stylesheet.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :"sass/#{params[:stylesheet]}"
end

get "/:username" do
  username = params[:username]
  
  begin

    @list = ObjectCache.get_or_set(username, :ttl => CACHE_TTL, :root => CACHE_ROOT) {
      List.new(username)
    }
    @user = @list.user
    haml :list

  rescue Delicious::NoSuchUser

    haml :no_such_user

  end
end

get "/:user/:tags" do
  "user is #{params[:user]} and tags are #{params[:tags]}"
end
