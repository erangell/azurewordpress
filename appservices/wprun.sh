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

# git the latest code
git clone "$GIT_REPO" /var/www

# Apache gets grumpy about PID files pre-existing
rm -f "$APACHE_PID_FILE"

# Run Apache in the foreground
exec apache2 -DFOREGROUND
