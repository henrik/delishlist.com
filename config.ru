if ENV['RACK_ENV'] == 'production'
  # Log is recreated on each restart, which is fine.
  log = File.new("log/sinatra.log", "w")
  $stdout.reopen(log)
  $stderr.reopen(log)
  
  # Get local gems working
  # http://stackoverflow.com/questions/1829973/deploying-sinatra-app-on-dreamhost-passenger-with-custom-gems/2571552#2571552
  ENV['GEM_HOME'] = '/home/delish/.gems'
  ENV['GEM_PATH'] = '$GEM_HOME:/usr/lib/ruby/gems/1.8'
  require 'rubygems'
  Gem.clear_paths
end

require 'app.rb'

disable :run
run Sinatra::Application
