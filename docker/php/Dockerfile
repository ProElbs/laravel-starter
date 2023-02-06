FROM composer:2.0 as composer

FROM php:8.2.1-fpm

RUN docker-php-ext-install pdo_mysql

RUN pecl install apcu

RUN apt-get update && \
apt-get install -y \
build-essential libssl-dev zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev libzip-dev

RUN docker-php-ext-install zip
RUN docker-php-ext-enable apcu
RUN docker-php-ext-install exif
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

WORKDIR /var/www/html

COPY --chown=1000:1000 laravel var/www/html

RUN PATH=$PATH:/var/www/html/vendor/bin:bin

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
