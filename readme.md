# WordPress using Azure MySQL and Azure App Services for Linux
* Based on Ubuntu, Apache and WordPress 4.7.5
* Uses this git repo to pull and update WordPress files
* SSL support with self-signed certificates (ignore the browser warning)
* SSL support for connecting to Azure MySQL
* Web tier runs on Azure App Services for Linux or any Docker container
* Includes Dockerfile for building custom images  
     For convenience, the Docker and SQL directories are in a single repo  
     This presents a security risk, so remove the directories from you production repo

## Replacements
* Replace westus1-a with your region
* Replace myserver with your server name
* Replace adminuser with your admin user name
* Replace WP-Passw0rd with your WordPress password  
     Don't forget to update create.sql
* Optionally replace wordpress database and/or user with your choice

## Installation
* Create an Azure MySQL database from the portal, CLI or PowerShell
* Open the MySQL firewall from the portal, CLI or PowerShell
* (optional) edit create.sql to update database, user and/or password
* Use Azure Cloud Shell to create the database and user and grant permissions
```
mysql -h myserver.mysql.database.azure.com -u adminuser@myserver -p < create.sql
   (Note that create.sql will delete the wordpress database if it exists!)
```

## Running from App Services for Linux
* Create an App Service for Linux instance from the portal, CLI or Powershell
* Set the docker container to bartr/wp
* Set the following parameters in the settings tab
```
WORDPRESS_DB_HOST=westus1-a.control.database.windows.net
WORDPRESS_DB_USER=wordpress@myserver
WORDPRESS_DB_PASSWORD=WP-Passw0rd
WORDPRESS_DB_NAME=wordpress
```

## Running from Docker
Make sure ports 80 and 443 are open on your Docker host and no other services are using the ports  
Note that WordPress embeds the FQDN into links, so you cannot reuse the database
```
docker run -it -p 80:80 -p 443:443 --name wordpress \
-e WORDPRESS_DB_HOST=westus1-a.control.database.windows.net \
-e WORDPRESS_DB_USER=wordpress@myserver \
-e WORDPRESS_DB_PASSWORD=WP-Passw0rd \
-e WORDPRESS_DB_NAME=wordpress \
bartr/wp
```
If you want to explore the container, you can override the command with bash  
/usr/local/wprun.sh is the script that starts WordPress  
WordPress files are located in /var/www/html

## Browse to your web endpoint
You should see the "famous WordPress 5 minute install" which will create a basic WordPress site automatically.

## Congratulations!
At this point, you should have a functioning WordPress site

## Building a custom container
The Docker directory contains everything necessary to customize the container  

* Update the files in docker/apache2/ssl with your certificate files
* Update the git clone in Dockerfile to pull from your repository  
     Note that the repo assumes an html directory and pulls to /var/www
* Some of the installed packages are for convenience and can be removed
* The Dockerfile is not optimized for size

## WordPress code changes
* wp-config uses the environment variables for MySQL connection information  
    This is great for testing but actual values should probably be used for production
* wp-config defines MYSQL_SSL_CA to support SSL to Azure MySQL
```
define('MYSQL_SSL_CA', '/etc/ssl/certs/Baltimore_CyberTrust_Root.pem');
```
* wp-config adds support for x-arr-ssl headers (used by App Services for Linux)
```
if (isset($_SERVER['HTTP_X_ARR_SSL'])) {
	$_SERVER['HTTPS'] = 'on';
}
```
* .htaccess redirects to SSL (including x-arr-ssl support)
```
RewriteEngine On
RewriteCond %{HTTP:X-ARR-SSL} ^$
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```
* wp-includes/wp-db.php is patched to support SSL to Azure MySQL
```
if ( defined('MYSQL_SSL_CA')) {
        mysqli_ssl_set($this->dbh,NULL,NULL,MYSQL_SSL_CA,NULL,NULL);
}
```
