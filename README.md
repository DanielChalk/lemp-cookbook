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

The cookbook is designed to be used for development sandboxes, simply use the default recipe and set the [lemp][database][password] attribute and you're ready to go.

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
| [lemp][root_base] | /var/www/ | the base directory used for your applications |
| [lemp][app_name] | lemp_app | name of your application, used to name hostfiles ,usernames and paths |
| [lemp][app_root] | /var/www/#{node['lemp']['app_name']} | the public folder of your application |
| [lemp][database][host] | localhost | hostname / ip address of your database server | 
| [lemp][database][client] | localhost | hostname / ip address of your application. used when creating database users and fixing them to a hostname |
| [lemp][database][username] | node['lemp']['app_name'] | username for your application's database user. |
| [lemp][database][password] | Nil | Password for your application's database users, an error will be raised if you do not set this! |
| [lemp][database][name] | [lemp][database][name] | name of your applications database |
| [lemp][nginx_index] | ["index.php", "index.html"] | index file for your application |
| [lemp][php_socket] | "127.0.0.1:9000" | The ip:port or socket php-fpm will listen on |
| [lemp][php_options] | See php options subsection below | php option to be set for your php-fpm pool |
| [lemp][php][packages] | See php packages below | php packages / extensions to be install via the package manager |

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

Some of these will be removed shortly leaving packages up to whoever is implementing this cookbook.

- php5-cli
- php5-dev
- php5-gd
- php5-mcrypt
- php5-memcache
- php5-mhash
- php5-imagick

# Recipes

## default

This is the go to file if you want to install everything on a single host, otherwise use the recipes for the parts you need.

## mysql

Depends on the mysql and database cookbooks

Some mysql cookbook attributes are overridden here for security and convenience 

- Creates the application database using the [lemp][database][name] or [lemp][app_name] attributes.
- Creates a user for your application using [lemp][database][username] or [lemp][app_name] attributes.
- Grants the application database user access to the application database using [lemp][database][username], [lemp][database][name], [lemp][database][client] and [lemp][database][password]. 

In future this recipe will be hardened, restricting the application from running DDL queries. Another database user will be created for this, you will need to configure your migrations to use this database user.

## nginx

Depends on the nginx cookbook

Some nginx cookbook attributes are override here to remove the detault site.

- Creates path for your application 
- Creates the nginx server for your application.

## php

Depends on the php-fpm cookbook

- Installs additional php packages specified in the [lemp][php][packages] attribute.
- Disables the default pool
- Creates a pool for your application


# Author

Author:: Daniel Chalk (<daniel-chalk@hotmail.co.uk>)
