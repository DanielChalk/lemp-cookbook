name 'lemp'
maintainer 'Daniel Chalk'
maintainer_email 'daniel-chalk@hotmail.co.uk'
license 'MIT'
description 'LEMP environment'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

supports "ubuntu"

depends "nginx"
depends "php-fpm"
depends "mysql"
depends "database"