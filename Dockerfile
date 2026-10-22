FROM php:8.3.36-fpm-alpine@sha256:aaf1ad25fc6484613be770743d1038e98e3e7e07409d78b97410eccdf3628f75

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
