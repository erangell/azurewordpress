# git the latest code
git clone "$GIT_REPO" /var/www

# Apache gets grumpy about PID files pre-existing
rm -f "$APACHE_PID_FILE"

# Run Apache in the foreground
exec apache2 -DFOREGROUND
