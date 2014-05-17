# -*- mode: ruby -*-
# vi: set ft=ruby :

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

Vagrant.configure("2") do |config|

	# box / image - on older versions of vagrant you will need the URL to the box
	config.vm.box = "ubuntu/trusty64"
	config.vm.box_url = "https://vagrantcloud.com/ubuntu/trusty64/version/1/provider/virtualbox.box"
	
	#networking
	config.vm.hostname = "lemp-cookbook"
	config.vm.network :private_network, ip: "33.33.33.10"
	
	# omnibus 
	config.omnibus.chef_version = :latest

	# berkshelf 
	config.berkshelf.enabled = true

	# virtual box
	config.vm.provider :virtualbox do |vb|
	  vb.memory = 256
	end

	config.vm.provision :chef_solo do |chef|
		chef.json = {
			:mysql => {
				:server_root_password => 'passwd',
				:server_debian_password => 'passwd',
				:server_repl_password => 'passwd'
			},
			:lemp => {
				:database => {
					:password => 'lemp_passwd'
				}
			}
		}

		chef.run_list = ["recipe[lemp]"]
	end
end
