require 'rubygems'
require 'bundler'
Bundler.require
require 'sass'  # Avoid "tilt" lib warnings.

cache_minutes = 15  # Since we can't reference settings from each other.
set :cache_minutes, cache_minutes
set :cache_seconds, cache_minutes * 60

if ENV['RACK_ENV'] == 'production'
  share_dir = "/use_memcache_instead/shared"
else
  share_dir = "/tmp/delishlist"
  FileUtils.mkdir_p share_dir
end
set :cache_root, "#{share_dir}/cache"

set :haml, :format => :html5, :attr_wrapper => %{"}

db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
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
