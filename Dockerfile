FROM ubuntu:latest
MAINTAINER atsu666

RUN apt-get -y update
# RUN apt-get -y install software-properties-common
# RUN apt-get -y install python-software-properties
# RUN add-apt-repository ppa:ondrej/php5
RUN apt-get -y update

# Install wget
RUN apt-get -y install wget

# Install apache
RUN apt-get -y install apache2
RUN /usr/sbin/a2enmod rewrite
ADD apache.conf apache.conf
RUN cat apache.conf >> /etc/apache2/sites-available/000-default.conf && \
    rm apache.conf

# Install php
RUN apt-get -y install libapache2-mod-php5 php5-mysql php5-gd

# Download ioncube loader
RUN cd /var/www/html && \
    wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
    tar zxvf ioncube_loaders_lin_x86-64.tar.gz && \
    rm ioncube_loaders_lin_x86-64.tar.gz && \
    echo "zend_extension = /var/www/html/ioncube/ioncube_loader_lin_5.5.so" > /etc/php5/apache2/php.ini

# Run
ADD run.sh run.sh
RUN chmod 755 /*.sh

EXPOSE 80
CMD ["./run.sh"]
