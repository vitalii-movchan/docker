# Start from the official PHP image
FROM php:8.4-cli

# Get any build argument overrides

# User
ARG USER_ID
ARG USER_NAME
ARG GROUP_ID
ARG GROUP_NAME

# Xdebug
ARG XDEBUG_VERSION
ARG XDEBUG_CLIENT_PORT
ARG XDEBUG_IDE_KEY

# Make container user
RUN addgroup --system --gid ${GROUP_ID} ${GROUP_NAME}
RUN adduser --system --shell /bin/sh --uid ${USER_ID} --ingroup ${GROUP_NAME} --disabled-password ${USER_NAME}

# Install packages
RUN yes | apt-get update

RUN yes | apt-get install \
    git \
    nano;

RUN rm -rf /var/cache/apt/*

# Install php extensions

# pecl install is the PHP Extension Community Library.
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

# Get latest Composer
COPY --from=composer:2.9.5 /usr/bin/composer /usr/bin/composer

# Copy the setup entrypoint into the container
COPY ./docker/php-cli/setup.sh /usr/local/bin/setup.sh

# Make the script executable
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/ledger-reconciliation

USER ${USER_NAME}

# Set the entrypoint to the shell entrypoint using JSON array syntax
ENTRYPOINT ["/usr/local/bin/setup.sh"]

# Define the default command to run after the entrypoint script finishes
CMD ["php"]
