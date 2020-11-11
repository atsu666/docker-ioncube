FROM php:5.4-apache
MAINTAINER atsu666

# apache user
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

# extension
RUN apt-get update \
    && apt-get install --yes --force-yes \
        libfreetype6-dev \
        libmagickwand-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        jpegoptim \
        optipng \
        gifsicle \
        sendmail \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysql

# ioncube loader
RUN curl -fsSL 'http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -o ioncube.tar.gz \
    && mkdir -p ioncube \
    && tar -xf ioncube.tar.gz -C ioncube --strip-components=1 \
    && rm ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.4.so /var/www/ioncube_loader_lin_5.4.so \
    && rm -r ioncube

# php.ini
COPY config/php.ini /usr/local/etc/php/

# apache
RUN a2enmod rewrite
RUN a2enmod ssl

COPY entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
