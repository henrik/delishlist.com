# Custom gem dir on Dreamhost:
# http://www.edschmalzle.com/2009/06/29/deploying-sinatra-with-passenger-on-dreamhost/
if ENV['RACK_ENV'] == 'production'
  ENV['GEM_HOME'] = '/home/delish/.gems'
  ENV['GEM_PATH'] = '$GEM_HOME:/usr/lib/ruby/gems/1.8'

  # Log is recreated on each restart, which is fine.
  log = File.new("log/sinatra.log", "w")
  $stdout.reopen(log)
  $stderr.reopen(log)
end

require 'app.rb'

disable :run
run Sinatra::Application
