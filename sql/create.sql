drop database if exists wordpress;

create database wordpress;

create user 'wordpress' IDENTIFIED BY "WP-Passw0rd"; 

GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'; 
FLUSH PRIVILEGES;

