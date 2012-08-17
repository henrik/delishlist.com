require "./app"

Airbrake.configure do |config|
  config.api_key = ENV["AIRBRAKE_API_KEY"]
end
use Airbrake::Rack

run Sinatra::Application
