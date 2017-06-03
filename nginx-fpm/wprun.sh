#!/bin/bash

if [ ! -d "/home/www" ]; then
  mkdir -p /home/www
fi

chown -R www-data.www-data /home/www
chmod -R 775 /home/www

if [ ! -d "/home/www/.git" ]; then
  git clone "$GIT_REPO" /home/www
else
  git -C /home/www pull
fi

# save the SSL cert if specified
if [[ $SSL_PEM && $SSL_KEY ]];
then
  echo -e "$SSL_PEM" > /etc/ssl/certs/wordpress.pem;
  echo -e "$SSL_KEY" > /etc/ssl/private/wordpress.key;
fi

if [ $WORDPRESS_DB_HOST ]; then
  sed -i "s/WORDPRESS_DB_HOST/$WORDPRESS_DB_HOST/g" /usr/local/wp-config.php
  echo "host=$WORDPRESS_DB_HOST" >> /etc/my.cnf
fi

if [ $WORDPRESS_DB_NAME ]; then
sed -i "s/WORDPRESS_DB_NAME/$WORDPRESS_DB_NAME/g" /usr/local/wp-config.php
  echo "database=$WORDPRESS_DB_NAME" >> /etc/my.cnf
fi

if [ $WORDPRESS_DB_USER ]; then
sed -i "s/WORDPRESS_DB_USER/$WORDPRESS_DB_USER/g" /usr/local/wp-config.php
  echo "user=$WORDPRESS_DB_USER" >> /etc/my.cnf
fi

if [ $WORDPRESS_DB_PASSWORD ]; then
sed -i "s/WORDPRESS_DB_PASSWORD/$WORDPRESS_DB_PASSWORD/g" /usr/local/wp-config.php
  echo "password=$WORDPRESS_DB_PASSWORD" >> /etc/my.cnf
fi

cp /usr/local/wp-config.php /home/www/html

unset WORDPRESS_DB_HOST
unset WORDPRESS_DB_NAME
unset WORDPRESS_DB_USER
unset WORDPRESS_DB_PASSWORD
unset SSL_PEM
unset SSL_KEY
unset GIT_REPO

# Start NGINX
if [ -d "/etc/nginx" ]; then
  exec /usr/bin/supervisord -n -c /etc/supervisord.conf
fi

if [ -d "/etc/apache2" ]; then
  rm -f "$APACHE_PID_FILE"
  exec apache2 -DFOREGROUND
fi
