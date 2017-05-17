pushd .
cd /var/www
git pull
popd

if test -f "$APACHE_ENVVARS"; then
        . "$APACHE_ENVVARS"
fi

# Apache gets grumpy about PID files pre-existing
rm -f "$APACHE_PID_FILE"

exec apache2 -DFOREGROUND "$@"
