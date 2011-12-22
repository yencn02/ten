
#
# (c)2007 ENDAX - 9ine Configuration

default_run_options[:pty] = true
set :application, "ten"
set :scm, "git"
set :repository,  "git@github.com:endax/ten.git"
set :branch, "master"
set :keep_releases, 3


task :production do
  # account info
  set :server_name, "10.endax.com"
  set :user, "deployer"
  set :deploy_to, "/var/www/#{application}"
  set :admin_runner, "deployer"
  set :apache_bin, "apache2"
  # roles
  role :app, "10.endax.com"
  role :web, "10.endax.com"
  role :db,  "10.endax.com", :primary => true
  
end

# persist configurations
task :appsymlink, :roles => [:app, :db] do  
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

desc "Cleanup fragment cache file directory."
task :cleanup_fragment_cache, :roles => :app, :only => { :primary => true } do
  sudo "rm -rf #{fragment_cache}/*"
end

namespace :deploy do
  desc "Restart Apache"
  task :restart, :roles => :app do
    sudo "/etc/init.d/#{apache_bin} restart"
  end
end


task :bundler, :roles => [:app] do
  run "cd #{current_path} && RAILS_ENV=production bundle install"
end

before "deploy:migrate", :cleanup_fragment_cache
after "deploy:update", :bundler
after "deploy:update", :appsymlink
after "deploy:update", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup", :cleanup_fragment_cache