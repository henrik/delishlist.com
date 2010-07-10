# Custom gem dir on Dreamhost:
# http://www.edschmalzle.com/2009/06/29/deploying-sinatra-with-passenger-on-dreamhost/
if ENV['RACK_ENV'] == 'production'
  ENV['GEM_HOME'] = '/home/delish/.gems'
  ENV['GEM_PATH'] = '$GEM_HOME:/usr/lib/ruby/gems/1.8'
end

require 'app.rb'

disable :run
run Sinatra::Application
