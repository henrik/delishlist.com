require 'capistrano_colors'
require 'bundler/capistrano'

# RVM: http://rvm.beginrescueend.com/integration/capistrano/
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"
set :rvm_ruby_string, 'ree'
set :rvm_type, :user

default_run_options[:pty] = true

set :user, 'henrik'
set :domain, 'delishlist.com'

# cap deploy:cleanup
set :keep_releases, 5

set :repository,  "/srv/git/#{domain}.git"
set :local_repository,  "#{user}@#{domain}:#{repository}"
set :deploy_to, "/srv/www/#{domain}"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

server domain, :app, :web

desc "Link in shared stuff"
task :after_update_code do
  run "ln -nfs #{shared_path}/log #{release_path}/log"
end

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
