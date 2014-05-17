# lemp cookbook

Linux Nginx MySQL PHP cookbook

This cookbook currently only supports Ubuntu but I can't see why it wouldn't work on other distributions.

# Requirements

This cookbook is dependant on the following cookbooks, these are specified in both Berksfile and metadata.rb:

- php-fpm
- nginx
- mysql
- database

# Usage

## Minimal node.json for a single host

The cookbook is designed to work with development sandboxes, simply use the default recipe and set the _lemp.database.password_ attribute and you're ready to go.

```json
{
	"runlist": ["recipe[lemp]"],
	"lemp": {
		"database": {
			"password": "G!v3M3aPa$$w0r|)Ple4$3"
		}
	}
}
```

## Minimal two host setup (Application & Database)

_application.json_
```json
{
	"runlist": ["recipe[lemp::php]", "recipe[lemp::nginx]"],
	"lemp": {
		"database": {
			"host": "database_hostname"
		}
	}
}
```

_database.json_
```json
{
	"runlist": ["recipe[lemp::mysql]"],
	"lemp": {
		"database": {
			"client": "application_hostname"
			"password": "G!v3M3aPa$$w0r|)Ple4$3"
		}
	}
}
```

# Attributes

| Name | Default | Description |
| --- | --- | --- |
| _lemp.root_base_ | /var/www/ | the base directory used for your applications |
| _lemp.app_name_ | lemp_app | name of your application, used to name hostfiles ,usernames and paths |
| _lemp.app_root_ | /var/www/#{node['lemp']['app_name']} | the public folder of your application |
| _lemp.database.host_ | localhost | hostname / ip address of your database server | 
| _lemp.database.client_ | localhost | hostname / ip address of your application. used when creating database users and fixing them to a hostname |
| _lemp.database.username_ | node['lemp']['app_name'] | username for your application's database user. |
| _lemp.database.password_ | Nil | Password for your application's database users, an error will be raised if you do not set this! |
| _lemp.database.name_ | node['lemp']['database']['name'] | name of your applications database |
| _lemp.nginx_index_ | ["index.php", "index.html"] | index file for your application |
| _lemp.php_socket_ | "127.0.0.1:9000" | The ip:port or socket php-fpm will listen on |
| _lemp.php_options_ | See php options subsection below | php option to be set for your php-fpm pool |
| _lemp.php.packages_ | See php packages below | php packages / extensions to be install via the package manager |

## php options

Some additiona effort is required here to determine the most sensible defaults.

### defaults

| Name | Value |
| --- | --- |
| php_admin_flag[log_errors] | on |
| php_admin_value[memory_limit] | 64M |

## php packages

I have only implemented Ubuntu PHP packages so far.

### ubuntu packages

Some of these will be removed shortly, leaving packages up to whoever is implementing this cookbook.

- php5-cli
- php5-dev
- php5-gd
- php5-mcrypt
- php5-memcache
- php5-mhash
- php5-imagick

# Recipes

## default

This is the go to recipe if you want to install everything on a single host, otherwise use the recipes for the parts you need.

## mysql

Depends on the __mysql__ and __database__ cookbooks

Some mysql cookbook attributes are overridden here for security and convenience 

- Creates the application database using the _lemp.database.name_ or _lemp.app_name_ attributes.
- Creates a user for your application using _lemp.database.username_ or _lemp.app_name_ attributes.
- Grants the application database user access to the application database using _lemp.database.username_, _lemp.database.name_, _lemp.database.client_ and _lemp.database.password_. 

In future this recipe will be hardened, restricting the application from running DDL statements. Another database user will be created for this, you will need to configure your migrations to use this database user.

## nginx

Depends on the __nginx__ cookbook

Some nginx cookbook attributes are override here to remove the detault site.

- Creates path for your application 
- Creates the nginx server for your application.

## php

Depends on the __php-fpm__ cookbook

- Installs additional php packages specified in the _lemp.php.packages_ attribute.
- Disables the default pool
- Creates a pool for your application


# Author

Author:: Daniel Chalk (<daniel-chalk@hotmail.co.uk>)
