require "rubygems"
require "sinatra"
require "json"
require "haml"
require "sass"
require "active_record"

cache_minutes = 15  # Since we can't reference settings from each other.
set :cache_minutes, cache_minutes
set :cache_seconds, cache_minutes * 60

if ENV['RACK_ENV'] == 'production'
  share_dir = "/srv/www/delishlist.com/shared"
else
  share_dir = "/tmp/delishlist"
  FileUtils.mkdir_p share_dir
end
set :cache_root, "#{share_dir}/cache"

set :haml, :format => :html5, :attr_wrapper => %{"}

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database =>  "#{share_dir}/delishlist.sqlite3.db"
)

Dir["{helpers,models,lib}/**/*.rb"].each { |f| require f }
