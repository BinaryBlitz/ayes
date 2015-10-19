require 'rvm/capistrano'
require 'bundler/capistrano'

load 'deploy/assets'

set :stages, %w(staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, 'ayes'
set :deploy_to, "/home/ayes/#{application}"
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :normalize_asset_timestamps, false
set :rvm_ruby_string, 'ruby-2.2.3@ayes'

set :scm, :git
set :repository, 'git@github.com:BinaryBlitz/ayes.git'

set :deploy_via, :remote_cache

before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'

after 'deploy:update_code', roles: :app do
  # Config
  run "rm -f #{current_release}/config/secrets.yml"
  run "ln -nfs #{deploy_to}/shared/config/secrets.yml #{current_release}/config/secrets.yml"

  # Uploads
  # run "rm -f #{current_release}/public/uploads"
  # run "ln -nfs #{deploy_to}/shared/public/uploads #{current_release}/public/uploads"

  run "cd #{current_release}; bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
end

before 'deploy:assets:precompile', 'deploy:link_db'

set :keep_releases, 3
after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  task :link_db do
    run "rm -f #{current_release}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
  end

  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end

  task :start do
    run "cd #{current_path}; bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end

  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
