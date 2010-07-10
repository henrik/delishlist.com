# Deploy to Dreamhost.

require 'capistrano_colors'

default_run_options[:pty] = true

set :user, 'delish'
set :domain, 'delishlist.com'
set :tempdomain, '83.250.124.96'  # Until DNS is changed.

# cap deploy:cleanup
set :keep_releases, 5

set :repository,  "git://github.com/henrik/delishlist.com.git"
set :deploy_to, "/home/#{user}/#{domain}"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

server tempdomain, :app, :web

desc "Link in shared stuff"
task :after_update_code do
  run "ln -nfs #{shared_path}/log #{release_path}/log"
end

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
