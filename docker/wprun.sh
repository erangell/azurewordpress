# save the SSL CRT if specified
if [[ $SSL_CRT ]];
then
  echo "$SSL_CRT" > /etc/ssl/apache.crt;
fi

# save the SSL Key if specified
if [[ $SSL_KEY ]];
 then
  echo "$SSL_KEY" > /etc/ssl/apache.key;
fi

# git the latest code
git clone "$GIT_REPO" /var/www

# Apache gets grumpy about PID files pre-existing
rm -f "$APACHE_PID_FILE"

# Run Apache in the foreground
exec apache2 -DFOREGROUND
