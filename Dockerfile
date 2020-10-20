FROM php:7.1.3-fpm

RUN apt-get clean -y
# Install the PHP extensions we need

RUN apt-get update && \
apt-get install -y --no-install-recommends \
    curl \
    git \
    mysql-client \
    libmemcached-dev \
    libz-dev \
    libzip-dev \
    libpq-dev \
    libjpeg-dev \
    libpng12-dev \
    libfreetype6-dev \
    libicu-dev \
    libssl-dev \
    libmemcached-dev \
    zlib1g-dev \
    libmcrypt-dev && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-install gd pdo_mysql mysqli opcache intl bcmath zip mcrypt sockets && \
    pecl install yaf-3.0.8 && \
    docker-php-ext-enable bcmath zip pdo_mysql mcrypt sockets yaf

# install memcached
RUN pecl install memcached

# install xdebug
RUN pecl install xdebug

# install redis
RUN pecl install redis

# install composer
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# config china mirror
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

VOLUME /app/web
WORKDIR /app/web