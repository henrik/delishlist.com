# Deploy to Dreamhost.

require 'capistrano_colors'

default_run_options[:pty] = true

set :user, 'henrik'
set :domain, 'delishlist.com'
set :temp_deploy_domain, 'nyh.name'

# cap deploy:cleanup
set :keep_releases, 5

set :repository,  "/srv/git/#{domain}.git"
set :local_repository,  "#{user}@#{temp_deploy_domain}:#{repository}"
set :deploy_to, "/srv/www/#{domain}"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

server temp_deploy_domain, :app, :web

desc "Link in shared stuff"
task :after_update_code do
  run "ln -nfs #{shared_path}/log #{release_path}/log"
end

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
