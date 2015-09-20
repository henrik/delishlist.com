task :environment do
  require_relative "setup.rb"
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
