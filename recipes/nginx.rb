#
# Cookbook Name:: lemp
# Recipe:: nginx
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

# stop the nginx cookbook from create the default site before we include the cookbook
node.set['nginx']['default_site_enabled'] = false
node.set['lemp']['app_root'] = "/var/www/#{node['lemp']['app_name']}" unless node['lemp']['app_root']

include_recipe "nginx"

directory node['lemp']['app_root'] do
	owner node['nginx']['user']
	group node['nginx']['group']
	mode "0755"
	recursive true
	action :create
end

# create a site for our application
lemp_site node['lemp']['app_name'] do
	server_names node['lemp']['server_names'] unless !node['lemp']['server_names']
	action :enable
end