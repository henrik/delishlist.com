source "https://rubygems.org"
ruby "2.2.2"

gem "sinatra", '~> 1.1.1', :git => "https://github.com/sinatra/sinatra.git"
gem "haml", '~> 3.0'
gem "json"
gem "hpricot"
gem "activerecord", :require => "active_record"
gem "pg"
gem "airbrake"
gem "dalli"
gem "memcachier"

group :production do
  gem "unicorn"
  gem "newrelic_rpm"
end
