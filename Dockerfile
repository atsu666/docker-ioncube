FROM php:7.1-apache
MAINTAINER atsu666

# apache user
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

# extension
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libmagickwand-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        jpegoptim \
        optipng \
        gifsicle \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && pecl install xdebug-2.5.0 \
        imagick \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable imagick

# ioncube loader
RUN curl -fsSL 'http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -o ioncube.tar.gz \
    && mkdir -p ioncube \
    && tar -xf ioncube.tar.gz -C ioncube --strip-components=1 \
    && rm ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.1.so /var/www/ioncube_loader_lin_7.1.so \
    && rm -r ioncube

# php.ini
COPY config/php.ini /usr/local/etc/php/

# apache user
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

# apache
RUN a2enmod rewrite
RUN a2enmod ssl

COPY entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]