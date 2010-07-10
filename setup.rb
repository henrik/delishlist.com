# We need these in app.rb or "ruby app.rb" won't work, and need them here
# or e.g. "irb -r setup" won't work.
require "rubygems"
require 'vendor/sinatra/lib/sinatra'  # Not pre-installed on Dreamhost.
require "json"  # TODO: vendor

cache_minutes = 15  # Since we can't reference settings from each other.
set :cache_minutes, cache_minutes
set :cache_seconds, cache_minutes * 60

if ENV['RACK_ENV'] == 'production'
  share_dir = "#{File.dirname(__FILE__)}/../shared/cache"
else
  share_dir = "/tmp/delishlist"
  FileUtils.mkdir_p share_dir
end
set :cache_root, "#{share_dir}/cache"

require "haml"
set :haml, :format => :html5, :attr_wrapper => %{"}

require "active_record"
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database =>  "#{share_dir}/delishlist.sqlite3.db"
)

Dir["{helpers,models,lib}/**/*.rb"].each { |f| require f }
