FROM alpine:3.5

MAINTAINER Spicer Mathtews <spicer@cloudmanic.com>

LABEL caddy_version="0.9.5" architecture="amd64"

# Essential pkgs
RUN apk add --no-cache openssh-client git tar php5-fpm curl bash vim

# Essential php magic
RUN apk add --no-cache php5-curl php5-dom php5-gd php5-ctype php5-zip php5-xml php5-iconv php5-mysql php5-sqlite3 php5-mysqli php5-pgsql php5-json php5-phar php5-openssl php5-pdo php5-mcrypt php5-pdo php5-pdo_pgsql php5-pdo_mysql

# Composer
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
      "https://getcomposer.org/installer" \
    | php5 -- --install-dir=/usr/bin --filename=composer

# Install caddy
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \  
 && /usr/bin/caddy -version

# Set port we run on because we run as a user.
EXPOSE 8080

# Ensure www-data user exists
RUN set -x \
	&& addgroup -g 33 -S www-data \
	&& adduser -u 33 -D -S -G www-data www-data

# Workint directory
WORKDIR /www

# Copy over default files
COPY Caddyfile /etc/Caddyfile
COPY index.php /www/public/index.php
COPY php-fpm.conf /etc/php5/php-fpm.conf

# Set perms for document root.
RUN chown -R www-data:www-data /www

# Setup log dir
RUN mkdir /logs && chown www-data:www-data /logs

# This needs to be at the bottom. 
USER www-data

CMD ["/usr/bin/caddy", "--conf", "/etc/Caddyfile"]