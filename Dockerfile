FROM php:7.4-fpm 

# Install the PHP extensions we need

RUN apt-get clean -y && \
apt-get update && \
apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    mariadb-client-10.3 \
    libmemcached-dev \
    libz-dev \
    libzip-dev \
    libpq-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev \
    libicu-dev \
    libssl-dev \
    libmemcached-dev \
    zlib1g-dev && \
    docker-php-ext-configure gd --with-jpeg --with-freetype && \
    docker-php-ext-install -j$(nproc) gd pdo_mysql pgsql pdo_pgsql mysqli opcache intl bcmath zip sockets && \
    docker-php-ext-enable bcmath zip pdo_mysql pgsql pdo_pgsql sockets

# install memcached redis
RUN pecl install memcached redis

# install xdebug
RUN pecl install xdebug 

# install yaf
RUN pecl install yaf && docker-php-ext-enable yaf

# install scws
RUN wget http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2  \
    && tar -xjf scws-1.2.3.tar.bz2  \
    && rm scws-1.2.3.tar.bz2  \
    && mv scws-1.2.3 /tmp  \
    && cd /tmp/scws-1.2.3  \
    && ./configure --prefix=/usr/local/scws  \
    && make  \
    && make install  \
    && cd /usr/local/scws/etc \
    && wget http://www.xunsearch.com/scws/down/scws-dict-chs-gbk.tar.bz2 \
    && wget http://www.xunsearch.com/scws/down/scws-dict-chs-utf8.tar.bz2 \
    && tar xvjf scws-dict-chs-gbk.tar.bz2 \
    && tar xvjf scws-dict-chs-utf8.tar.bz2 \
    && cd /tmp/scws-1.2.3/phpext \
    && phpize \
    && ./configure --with-scws=/usr/local/scws \
    && make  \
    && make install 

# install composer
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# config china mirror
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

VOLUME /app/web
WORKDIR /app/web