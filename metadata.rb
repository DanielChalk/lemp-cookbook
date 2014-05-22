name 'lemp'
maintainer 'Daniel Chalk'
maintainer_email 'daniel-chalk@hotmail.co.uk'
license 'MIT'
description 'LEMP environment'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.1'

supports "centos"

depends "nginx"
depends "php54"
depends "mysql"
depends "database"
