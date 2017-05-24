if [ ! -d "/home/www" ]; then
  mkdir -p /home/www
fi

chown -R www-data:www-data /home/www
chmod -R 775 /home/www

if [ ! -d "/home/www/.git" ]; then
  git clone "$GIT_REPO" /home/www
else
  git -C /home/www pull
fi

# save the SSL PEM if specified
if [[ $SSL_PEM ]];
then
  echo -e "$SSL_PEM" > /etc/ssl/certs/apache.pem;
fi

# save the SSL Key if specified
if [[ $SSL_KEY ]];
 then
  echo -e "$SSL_KEY" > /etc/ssl/private/apache.key;
fi

# Remove Apache PID file
rm -f "$APACHE_PID_FILE"

# Run Apache in the foreground
exec apache2 -DFOREGROUND

