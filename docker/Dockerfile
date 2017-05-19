FROM ubuntu
MAINTAINER bartr
EXPOSE 80
EXPOSE 443

RUN mkdir -p /var/lock/apache2 && mkdir -p /var/log/apache2 && mkdir -p /var/run/apache2
RUN apt-get update -y && apt-get install -y apt-utils nano git curl wget apache2 php libapache2-mod-php php-mcrypt php-mysql

COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

WORKDIR "/usr/local"
COPY wprun.sh /usr/local
RUN chmod +x wprun.sh

ENV APACHE_CONFDIR=/etc/apache2
ENV APACHE_ENVVARS=/etc/apache2/envvars
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_LOG_DIR=/var/log/apache2
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_PID_FILE=/var/run/apache2/apache2.pid
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data

ENV GIT_REPO=https://github.com/bartr/azurewordpress.git
ENV WORDPRESS_DB_HOST=westus1-a.control.database.windows.net
ENV WORDPRESS_DB_NAME=wordpress
ENV FORCE_SSL=true

RUN cp /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/apache.crt && cp /etc/ssl/private/ssl-cert-snakeoil.key  /etc/ssl/private/apache.key

RUN rm -R /var/www/html && chown -R www-data:www-data /var/www && chmod -R 775 /var/www

RUN a2enmod rewrite && a2enmod ssl && a2ensite default-ssl.conf

CMD ["bash", "wprun.sh"]
