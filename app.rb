require "rubygems"
require 'vendor/sinatra/lib/sinatra'  # Not pre-installed on Dreamhost.

require "#{File.dirname(__FILE__)}/setup.rb"

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
