task :environment do
  require "rubygems"
  require "sinatra"
  require "setup.rb"
end

namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    require "logger"
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("migrate")
  end
end