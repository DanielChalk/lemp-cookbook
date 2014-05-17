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

define :lemp_site, :action => :enable, :index => ["index.php"], :listen => 80, :server_names => [] do
	
	if params[:action] == :enable
		params[:server_names] = [node['ipaddress']].concat params[:server_names]
		params[:root] = node['lemp']['app_root'] unless params[:root]
		params[:socket] = node['lemp']['php_socket'] unless params[:socket]

		directory params[:root] do
			owner "www-data"
			group "www-data"
			mode "0755"
			action :create
		end

		# create our template
		template "#{node['nginx']['dir']}/sites-available/#{params[:name]}" do
			source "nginxsite.erb";
			mode 0644
			owner "www-data"
			group "www-data"
			cookbook params[:cookbook] if params[:cookbook]
			variables :params => params
			action :create
		end
	end

	# enable / disable the application
	nginx_site params[:name] do
		action params[:action]
    end

end
