FROM ubuntu
MAINTAINER bartr
EXPOSE 80
EXPOSE 443

RUN mkdir -p /var/lock/apache2 && mkdir -p /var/log/apache2 && mkdir -p /var/run/apache2 && \
apt-get update -y && \
apt-get install -y git apache2 php libapache2-mod-php php-mcrypt php-mysql \
apt-utils nano curl wget mysql-client-core-5.7

ENV APACHE_CONFDIR=/etc/apache2 \
APACHE_ENVVARS=/etc/apache2/envvars \
APACHE_LOCK_DIR=/var/lock/apache2 \
APACHE_LOG_DIR=/var/log/apache2 \
APACHE_RUN_DIR=/var/run/apache2 \
APACHE_PID_FILE=/var/run/apache2/apache2.pid \
APACHE_RUN_USER=www-data \
APACHE_RUN_GROUP=www-data \
GIT_REPO=https://github.com/bartr/wordpressfiles.git \
WORDPRESS_DB_HOST=westus1-a.control.database.windows.net \
WORDPRESS_DB_NAME=wordpress \
FORCE_SSL=true

WORKDIR "/usr/local"
COPY wprun.sh wp-config.php /usr/local/

RUN chmod +x wprun.sh && \
cp /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/apache.pem && \
cp /etc/ssl/private/ssl-cert-snakeoil.key  /etc/ssl/private/apache.key && \
rm -R /var/www/html && \
a2enmod rewrite && \
a2enmod ssl && \
a2ensite default-ssl.conf && \
sed -i "s@/var/www@/home/www@" /etc/apache2/sites-enabled/default-ssl.conf && \
sed -i "s@/var/www@/home/www@" /etc/apache2/sites-enabled/000-default.conf && \
sed -i "s@/var/www@/home/www@" /etc/apache2/apache2.conf && \
echo -e "[client]\nssl-mode=VERIFY_CA\nssl-ca=/etc/ssl/certs/Baltimore_CyberTrust_Root.pem" > /etc/my.cnf

CMD ["bash", "wprun.sh"]
