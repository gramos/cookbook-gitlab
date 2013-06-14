#
# Cookbook Name:: gitlab
# Recipe:: database
#

postgresql = node['postgresql']
gitlab = node['gitlab']

# 5.Database
include_recipe "postgresql::server"
include_recipe "database::postgresql"

postgresql_connexion = {
      :host => 'localhost',
  :username => 'postgres',
  :password => postgresql['password']['postgres']
}

## Create a user for GitLab.
postgresql_database_user gitlab['user'] do
  connection postgresql_connexion
    password gitlab['database_password']
      action :create
end

## Create the GitLab production database & grant all privileges on database
postgresql_database "gitlabhq_production" do
  connection postgresql_connexion
      action :create
end

postgresql_database_user gitlab['user'] do
     connection postgresql_connexion
  database_name "gitlabhq_production"
       password gitlab['database_password']
         action :grant
end