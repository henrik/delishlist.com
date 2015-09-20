require 'rubygems'
require 'bundler'
Bundler.require
require 'sass'  # Avoid "tilt" lib warnings.

# Defined in ENV on Heroku. To try locally, start memcached and uncomment:
#ENV['MEMCACHE_SERVERS'] = "localhost"

cache_minutes = 15  # Since we can't reference settings from each other.
set :cache_minutes, cache_minutes
set :cache_seconds, cache_minutes * 60

set :cache, (ENV["MEMCACHE_SERVERS"] ? Dalli::Client.new : nil)

set :haml, :format => :html5, :attr_wrapper => %{"}

db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/delishlist_dev')
ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :port     => db.port,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

Dir["./{helpers,models,lib}/**/*.rb"].each { |f| require f }
