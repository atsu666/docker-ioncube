FROM php:7.0-apache
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
        libpng-dev \
        jpegoptim \
        optipng \
        gifsicle \
        curl \
        zip \
        unzip \
        sendmail \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# ioncube loader
RUN curl -fSL 'http://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.zip' -o ioncube.zip \
    && mkdir -p ioncube \
    && unzip ioncube.zip \
    && rm ioncube.zip \
    && mv ioncube/ioncube_loader_lin_7.0.so /var/www/ioncube_loader_lin_7.0.so \
    && rm -r ioncube

# php.ini
COPY config/php.ini /usr/local/etc/php/

# apache
RUN echo "Mutex posixsem" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite
RUN a2enmod ssl

COPY entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]