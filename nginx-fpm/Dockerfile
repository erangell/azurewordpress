FROM ubuntu
MAINTAINER bartr

EXPOSE 80 443

WORKDIR /usr/local

RUN dpkg-divert --local --rename --add /sbin/initctl \
&&  ln -sf /bin/true /sbin/initctl \
&&  apt-get update \
&&  apt-get -y upgrade \
&&  apt-get -y install \
ca-certificates \
libedit2 \
libsqlite3-0 \
libxml2 \
xz-utils \
libcurl4-openssl-dev \
libedit-dev \
libsqlite3-dev \
libssl-dev \
libxml2-dev \
nano \
mysql-client \
nginx \
php7.0-fpm \
php7.0-mysql \
php-apcu \
pwgen \
python-setuptools \
curl \
git \
unzip \
php7.0-curl \
php7.0-gd \
php7.0-intl php-pear \
php-imagick \
php7.0-imap \
php7.0-mcrypt \
php-memcache \
php7.0-pspell \
php7.0-recode \
php-sqlite3 \
php7.0-tidy \
php7.0-xmlrpc \
php7.0-xsl \
libjpeg-dev \
libpng12-dev \
supervisor


# nginx config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini \
&&  sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/fpm/php.ini \
&&  sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/fpm/php.ini \
&&  sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf \
&&  sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.0/fpm/pool.d/www.conf \
&&  find /etc/php/7.0/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \; \
&&  sed -i -e "s@/run/php/php7.0-fpm.sock@127.0.0.1:9000@g" /etc/php/7.0/fpm/pool.d/www.conf \
&&  rm -Rf /etc/nginx/nginx.conf \
&&  mkdir -p /etc/nginx/sites-available/ \
&&  mkdir -p /etc/nginx/sites-enabled/ \
&&  rm /etc/nginx/sites-available/* \
&&  rm /etc/nginx/sites-enabled/*
#&& sed -i "s@;clear_env = no@clear_env = no@" /etc/php/7.0/fpm/pool.d/www.conf


# Let the conatiner know that there is no tty
#ENV DEBIAN_FRONTEND noninteractive

ENV GIT_REPO=https://github.com/bartr/wordpressfiles.git \
WORDPRESS_DB_HOST=westus1-a.control.database.windows.net \
WORDPRESS_DB_NAME=wordpress

COPY wprun.sh wp-config.php /usr/local/
COPY etc  /etc/

RUN chmod 755 /usr/local/wprun.sh \
&& cp /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled \
&& /usr/bin/easy_install supervisor \
&& /usr/bin/easy_install supervisor-stdout \
&& echo "[client]\nssl-mode=VERIFY_CA\nssl-ca=/etc/ssl/certs/Baltimore_CyberTrust_Root.pem" > /etc/my.cnf

CMD ["/usr/local/wprun.sh"]
