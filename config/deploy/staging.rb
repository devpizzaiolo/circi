# server "23.253.89.111:50000", :app, :web, :db, :primary => true
# set :deploy_to, "/home/administrator/www/www.pizzaiolo.ca"

server "138.197.130.148", :app, :web, :db, :primary => true
set :branch, 'staging3'
set :stage, :staging
set :keep_releases, 3
set :deploy_to, "/home/root/apps/staging.pizzaiolo.ca"