## WordPress using Azure MySQL and Azure App Services for Linux
* Based on Ubuntu 16.04, Apache2 and WordPress 4.7.5    
  or    
  Ubuntu 16.04, NGINX, PHP-FPM and WordPress4.7.5
* Uses git repo to pull and update WordPress source files    
    https://github.com/bartr/wordpressfiles/
* SSL support with self-signed certificates (ignore the browser warning)    
    Replace keys with your SSL values via environment variables
* SSL support for connecting to Azure MySQL
* Web tier runs on Azure App Services for Linux or any Docker container
* Includes Dockerfile for building custom images  

## Replacements
* Replace westus1-a with your region
* Replace myserver with your server name
* Replace adminuser with your admin user name
* Replace WP-Passw0rd with your WordPress password  
     Don't forget to update the MySQL commands
* (optional) Replace wordpress database and/or user with your choice
* (optional) Replace GIT_REPO with your URL

## Installation
* Create an Azure MySQL database from the portal, CLI or PowerShell
* Open the MySQL firewall from the portal, CLI or PowerShell
* (optional) update database, user and/or password in MySQL commands
* Use Azure Cloud Shell to create the database and user and grant permissions
```
mysql -h myserver.mysql.database.azure.com -u adminuser@myserver -p

/* MySQL Commands */

/* drop database if exists wordpress; */

create user 'wordpress' IDENTIFIED BY "WP-Passw0rd";

create database wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress';
FLUSH PRIVILEGES;
```

## Running from App Services for Linux
* Create an App Service for Linux instance from the portal, CLI or Powershell
* Set the docker container to bartr/apache-wordpress or bartr/nginx-wordpress
* Set the following parameters in the settings tab
```
WORDPRESS_DB_USER=wordpress@myserver
WORDPRESS_DB_PASSWORD=WP-Passw0rd

Optional with default values:
WORDPRESS_DB_HOST=westus1-a.control.database.windows.net
WORDPRESS_DB_NAME=wordpress
GIT_REPO=https://github.com/bartr/wordpressfiles.git
```

## Browse to your web endpoint
You should see the "famous WordPress 5 minute install" which will create a basic WordPress site automatically.

## Congratulations!
At this point, you should have a functioning WordPress site

## Running from Docker
Make sure ports 80 and 443 are open on your Docker host and no other services are using the ports  
Note that WordPress embeds the FQDN into links, so you cannot reuse the database  

Short Syntax (using defaults)
```
docker run -it -p 80:80 -p 443:443 --name wordpress \
-e WORDPRESS_DB_USER=wordpress@myserver \
-e WORDPRESS_DB_PASSWORD=WP-Passw0rd \
bartr/apache-wordpress
```

Full Syntax  
```
docker run -it -p 80:80 -p 443:443 --name wordpress \
-e WORDPRESS_DB_USER=wordpress@myserver \
-e WORDPRESS_DB_PASSWORD=WP-Passw0rd \
-e WORDPRESS_DB_HOST=westus1-a.control.database.windows.net \
-e WORDPRESS_DB_NAME=wordpress \
-e GIT_REPO=https://github.com/bartr/wordpressfiles.git \
-e FORCE_SSL=true \
-e SSL_PEM='Your SSL Cert' \
-e SSL_KEY='Your SSL Key' \
bartr/apache-wordpress
```

## Exploring the container contents
If you want to explore the container, you can override the command with bash  
```
docker run -it -p 80:80 -p 443:443 --name wordpress \
-e WORDPRESS_DB_USER=wordpress@myserver \
-e WORDPRESS_DB_PASSWORD=WP-Passw0rd \
bartr/apache-wordpress bash

You must run the git command to pull the WordPress files as they are not in the container  
mkdir -p /home/www
git clone "$GIT_REPO" /home/www

Git the latest version (after running git clone)
git -C /home/www pull

WordPress files are located in /home/www/html  

/usr/local/wprun.sh is the script that starts WordPress    
```

## Building a custom container
* The docker directory contains everything necessary to build the container  
Most customizations can be accomplished by using environment variables    
* Update the GIT_REPO environment variable to pull from your repository  
     Note that the repo assumes an html directory and pulls to /home/www
* Some of the installed packages are for convenience and can be removed
* The Dockerfile is not optimized for size
