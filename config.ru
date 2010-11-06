if ENV['RACK_ENV'] == 'production'
  # Log is recreated on each restart, which is fine.
  log = File.new("log/sinatra.log", "w")
  $stdout.reopen(log)
  $stderr.reopen(log)
end

require 'app.rb'

disable :run
run Sinatra::Application
