FROM php:7.4-fpm-alpine
RUN set -ex
RUN apk add --no-cache \
    $PHPIZE_DEPS \
    openssl-dev \
    postgresql-dev \
    sqlite-dev && \
    docker-php-ext-install pdo pdo_pgsql pdo_sqlite && \
    docker-php-ext-enable pdo pdo_pgsql pdo_sqlite && \
    docker-php-ext-install bcmath && \
    docker-php-ext-enable bcmath && \
    docker-php-ext-install opcache && \
    docker-php-ext-enable opcache && \
    rm -rf /tmp/pear

RUN apk add --update npm yarn
RUN pecl install mongodb

RUN  mkdir -p /var/www/html
RUN  mkdir -p /var/www/html/var/log/

COPY ./php.ini /usr/local/etc/php/php.ini
COPY ./php-fpm-pool.conf /etc/php7/php-fpm.d/www.conf

