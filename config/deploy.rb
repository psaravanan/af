#require 'bundler/capistrano'

role :web, "node1252.speedyrails.net"
role :app, "node1252.speedyrails.net"
role :db,  "node1252.speedyrails.net", :primary => true
set :repository, "git://github.com/psaravanan/af.git"

set :application, "americasfarmstand"

set :deploy_to, "/var/www/apps/#{application}"

set :user, "deploy"
set :password, "8GMV64ayfT"
set :group, "www-data"

set :deploy_via, :remote_cache
set :scm, "git"
set :keep_releases, 5

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs" #, "deploy:symlink_custom"

namespace :deploy do

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{deploy_to}/#{shared_dir}/tmp/restart.txt"
  end

  desc "Tasks to execute after code update"
  task :symlink_configs, :roles => [:app] do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "if [ -d #{release_path}/tmp ]; then rm -rf #{release_path}/tmp; fi; ln -nfs #{deploy_to}/#{shared_dir}/tmp #{release_path}/tmp"
  end

  desc "Custom Symlinks"
  task :symlink_custom, :roles => [:app] do
  end

end
