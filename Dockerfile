FROM ubuntu:16.04

# Recreate www-data user with UID 1000. This will avoid permission
# conflicts between host user and www-data accessing the same files.
#
# Note: The UID is the default UID for ubuntu installations. Other
#       distributions may use another UID.
RUN deluser www-data && useradd -ms /bin/bash -u 1000 -U www-data

# Define default answers for debconf and set
# debian frontend to noninteractive mode.
COPY scripts/*.sh /scripts/
RUN chmod +x /scripts/*
RUN /scripts/defaults.sh
RUN export DEBIAN_FRONTEND=noninteractive

ADD https://deb.nodesource.com/setup_6.x /scripts/nodejs.sh
RUN chmod +x /scripts/nodejs.sh && sync && /scripts/nodejs.sh
RUN rm -f /scripts/nodejs.sh

# Install packages
RUN apt-get clean && apt-get -y update && apt-get install -y locales software-properties-common \
  && locale-gen en_US.UTF-8
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt -y update && apt install -y --no-install-recommends \
    git \
    nginx \
    php7.1 \
    php7.1-gd \
    php7.1-curl \
    php7.1-fpm \
    php7.1-mbstring \
    php7.1-mysql \
    php7.1-tidy \
    php7.1-zip \
    php7.1-xml \
    php7.1-redis \
    php7.1-soap \
    php7.1-mcrypt \
    php7.1-intl \
    php7.1-bcmath \
    php7.1-xdebug \
    mysql-client-5.7 \
    nodejs \
    supervisor \
    wget \
    # zip needed to install composer depencencies inside the container
    zip \
    # bzip2 needed to install npm dependencies inside the container
    bzip2 \
    # msmtp-mta needed to send emails using smtp inside the container
    msmtp-mta \
    && rm -rf /var/lib/apt/lists/* && echo 'Packages installed and lists cleaned'

RUN /scripts/setup-composer.sh && mv composer.phar /usr/bin/composer && composer global require hirak/prestissimo

# Install npm development packages
RUN npm install -g grunt

# Add configuration files
COPY conf/php/* /etc/php/7.1/fpm/conf.d
COPY conf/nginx/conf.d/* /etc/nginx/conf.d
COPY conf/nginx/sites/* /etc/nginx/sites-enabled
COPY conf/nginx/sites/* /etc/nginx/sites-available
COPY conf/supervisor/* /etc/supervisor/conf.d/
COPY conf/supervisord.conf /etc/supervisor/supervisord.conf

# Disable default site on nginx
RUN rm -rf /etc/nginx/sites-enabled/default

# Disable daemon mode on php-fpm
RUN sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php/7.1/fpm/php-fpm.conf

# Create run directories for mysql and php-fpm
RUN mkdir /var/run/php

# Expose HTTP port
EXPOSE 80

WORKDIR /var/www

CMD ["/scripts/run.sh"]

