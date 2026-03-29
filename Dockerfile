FROM php:8.5.4-fpm-alpine@sha256:0b842919dc0aaed33eb5d57c7002f9f2d0120972d59db610cb6bdb69ad7624f0

COPY php.ini /usr/local/etc/php/conf.d/php.ini

RUN apk update && \
    apk upgrade

RUN apk add --no-cache \
    autoconf \
    gcc \
    git \
    libc-dev \
    make \
    libpng-dev \
    libjpeg-turbo-dev \
    linux-headers \
    openssl-dev \
    tzdata && \
    ln -s /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    docker-php-ext-configure gd -enable-gd --with-jpeg && \
    docker-php-ext-install bcmath gd pdo_mysql && \
    pecl install mongodb && \
    docker-php-ext-enable mongodb && \
    docker-php-ext-install sockets && \
    rm -rf /tmp/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"
