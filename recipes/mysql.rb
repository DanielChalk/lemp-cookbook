#
# Cookbook Name:: lemp
# Recipe:: mysql
#
# Copyright (C) 2014 Daniel Chalk
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Overrides for the mysql cookbook to make sure silly things don't happen by mistake.
node.set['mysql']['remove_anonymous_users'] = true
node.set['mysql']['allow_remote_root'] = false
node.set['mysql']['remove_test_database'] = true

# User lemp.app_name for lemp.database.name and lemp.database.username if they haven't already been set for the node.
node.set['lemp']['database']['name'] = node['lemp']['app_name'] unless node['lemp']['database']['name']
node.set['lemp']['database']['username'] = node['lemp']['app_name'] unless node['lemp']['database']['username']

# Force a password to be assigned 
raise "node['lemp']['database']['password'] must be set" unless node['lemp']['database']['password']

# Nows lets start installing stuff
include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "mysql::ruby"

include_recipe "database"

# Root connection details so we can start creating users and databases
root_mysql_info = {
	:host  => 'localhost',
	:username  => 'root',
	:password  => node['mysql']['server_root_password']
}

# Create our application database
mysql_database node['lemp']['database']['name'] do
	connection root_mysql_info
	action :create
end

# Create our application user
mysql_database_user node['lemp']['database']['username'] do
	connection root_mysql_info
	action :create
end

# Create grants for our application user
mysql_database_user node['lemp']['database']['username'] do
	connection root_mysql_info
	password node['lemp']['database']['password']
	database_name node['lemp']['database']['name']
	host node['lemp']['database']['client']
	privileges [:all]
	action :grant
end