# set :application, "set your application name here"
# set :repository,  "set your repository location here"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

# role :app, "your app-server here"
# role :web, "your web-server here"
# role :db,  "your db-server here", :primary => true

default_run_options[:pty] = true
set :ssh_options, {:forward_agent => true}

set :github_user, 'potage'
set :github_application, 'potage'
set :domain, 'potage.org'
set :user, 'mat5uda'

set :application, 'blog'
# set :repository,  "git@github.com:#{github_user}/#{github_application}.git"
set :repository,  "git://github.com/#{github_user}/#{github_application}.git"

set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

set :deploy_to, "/home/#{user}/#{application}.#{domain}"
set :deploy_via, :remote_cache
# set :deploy_via, :copy
# set :copy_remote_dir, "#{shared_path}/tmp"
# set :copy_strategy, :export

set :use_sudo, false

server domain, :app, :web

# set :keep_releases, 3
# after "deploy:update", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
