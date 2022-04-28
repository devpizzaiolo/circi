require 'capistrano/ext/multistage'
require 'bundler/capistrano'

# sdekiq restart stuffs -->
require 'sidekiq/capistrano'

set :stages, ["staging", "production"]
set :default_stage, "staging"
set :repo_url, 'git@github.com:metaware/pizzaiolo.ca.git'

set :application, "pizzaiolo.ca"
set :user, 'root'
set :use_sudo, false

set :rvm_type, :system

set :scm, :git
set :ssh_options, { forward_agent: true }
set :keep_releases, 3
set :repository,  "git@github.com:metaware/pizzaiolo.ca.git"

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    
    # create the symlink for invoices
    # NOTE - invoice directory must exist for this to work!
    # shared_assets.each { |link| run "ln -nfs #{shared_path}/#{link} #{release_path}/#{link}" }
  

    # run migrations (if there are any)
    run "cd #{deploy_to}/current && bundle exec rake db:migrate RAILS_ENV=production"
    
    # restart the rails application
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "#{try_sudo} mkdir #{File.join(current_path,'public','uploads')}"
    run "#{try_sudo} mkdir #{File.join(current_path,'public','uploads', 'tmp')}"
    run "#{try_sudo} chmod 755 #{File.join(current_path,'public','uploads', 'tmp')}"
    run "#{try_sudo} chown www-data #{File.join(current_path,'public','uploads', 'tmp')}"
    
  end
  
  
  
  
  task :cold do
    transaction do
      update
      setup_db  #replacing migrate in original
      start
    end
  end

  task :setup_db, :roles => :app do
    run "cd #{current_path}; bundle exec rake db:create RAILS_ENV=#{rails_env}"
  end
  
  
  
  
end

# sitemap stuff only enabled for production server

require './config/boot'
# require 'airbrake/capistrano'
require "rvm/capistrano"