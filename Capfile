load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

default_run_options[:pty] = true

set :github_user, 'potage'
set :github_application, 'potage'
set :domain, 'potage.org'
set :user, 'mat5uda'

set :application, 'blog'
set :repository,  "git@github.com:#{github_user}/#{github_application}.git"

set :deply_to, "/home/#{user}/#{application}.#{domain}"
set :deply_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

server domain, :app, :web

# set :keep_releases, 3
# after "deploy:update", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
