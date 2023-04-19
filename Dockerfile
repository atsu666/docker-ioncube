FROM php:7.4-apache
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
        libwebp-dev \
        libzip-dev \
        jpegoptim \
        optipng \
        gifsicle \
        sendmail \
        git-core \
        build-essential \
        openssl \
        libssl-dev \
        libonig-dev \
        python2.7 \
        zip \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bcmath \
    && docker-php-ext-enable mysqli \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && ln -s /usr/bin/python2.7 /usr/bin/python

# ioncube loader
RUN curl -fSL 'http://downloads.ioncube.com/loader_downloads/ioncube_loaders_dar_arm64.zip' -o ioncube.zip \
    && mkdir -p ioncube \
    && unzip ioncube.zip \
    && rm ioncube.zip \
    && mv ioncube/ioncube_loader_dar_7.4.so /var/www/ioncube_loader_dar_7.4.so \
    && rm -r ioncube

# composer
RUN curl -S https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update

# node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && . $NVM_DIR/nvm.sh \
    && nvm install v12.22.12 \
    && nvm use v12.22.12 \
    && nvm alias default v12.22.12 \
    && npm install -g npm@6.14.16

# php.ini
COPY config/php.ini /usr/local/etc/php/

# apache user
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

# apache
RUN echo "Mutex posixsem" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite
RUN a2enmod ssl

COPY entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
