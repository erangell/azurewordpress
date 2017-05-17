# WordPress using Azure MySQL and Azure App Services for Linux
* Based on Ubuntu, Apache and WordPress 4.7.5
* Calls git pull on start
* SSL support with self-signed certificates (ignore the browser warning)
* SSL support for connecting to Azure MySQL
* Web tier runs on Azure App Services for Linux or any Docker container

## Replacements
* Replace westus1-a with your region
* Replace myserver with your server name
* Replace adminuser with your admin user name
* Replace Azure2017 with your WordPress password
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

## Running from Docker
Make sure ports 80 and 443 are open on your Docker host and no other services are using the ports
```
docker run -it -p 80:80 -p 443:443 --name wordpress \
-e WORDPRESS_DB_HOST=westus1-a.control.database.windows.net \
-e WORDPRESS_DB_USER=wordpress@myserver \
-e WORDPRESS_DB_PASSWORD=Azure2017 \
-e WORDPRESS_DB_NAME=wordpress \
bartr/wp
```
If you want to explore the container, you can override the command with bash  
/usr/local/wprun.sh is the script that starts WordPress  
WordPress files are located in /var/www/html


## Running from App Services for Linux
* Create an App Service for Linux instance from the portal, CLI or Powershell
* Set the docker container to bartr/wp
* Set the following parameters in the settings tab
```
WORDPRESS_DB_HOST=westus1-a.control.database.windows.net
WORDPRESS_DB_USER=wordpress@myserver
WORDPRESS_DB_PASSWORD=Azure2017
WORDPRESS_DB_NAME=wordpress
```

