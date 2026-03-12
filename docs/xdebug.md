# Dockerfile

# Install php extensions

# PECL install is the PHP Extension Community Library.
# Xdebug 3.2 is not supported with anything below PHP 8.0.
RUN yes | pecl install xdebug-${XDEBUG_VERSION};

# Enable php extensions
RUN docker-php-ext-enable xdebug

# Configure xdebug
RUN echo "xdebug.mode=debug,coverage,develop" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.log_level=3" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_port=${XDEBUG_CLIENT_PORT}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.log=/var/www/ledger-reconciliation/storage/logs/xdebug-fpm.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey = ${XDEBUG_IDE_KEY}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Docker composer
application:
    build:
        context: .
        dockerfile: docker/php-cli/Dockerfile
    args:
        XDEBUG_VERSION: "${XDEBUG_VERSION:-3.5.0}"
        XDEBUG_CLIENT_PORT: "${XDEBUG_CLIENT_PORT:-9001}"
        XDEBUG_IDE_KEY: "${XDEBUG_IDE_KEY:-PHPSTORM}"
    container_name: application
    extra_hosts:
        - host.docker.internal:host-gateway

# ENV
