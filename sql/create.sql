drop database if exists wordpress;

create database wordpress;

create user 'wordpress' IDENTIFIED BY "Azure2017"; 

GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'; 
FLUSH PRIVILEGES;

