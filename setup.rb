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
