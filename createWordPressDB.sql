/* drop database if exists wordpress; */

create database wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress' IDENTIFIED BY 'WP-Passw0rd';
FLUSH PRIVILEGES;
