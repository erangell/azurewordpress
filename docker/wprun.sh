# git the latest code
pushd .
cd /var/www
git pull
popd

# Apache gets grumpy about PID files pre-existing
rm -f "$APACHE_PID_FILE"

# Run Apache in the foreground
exec apache2 -DFOREGROUND
