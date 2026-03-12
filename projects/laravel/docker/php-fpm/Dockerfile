FROM php:fpm-alpine

# Get any build argument overrides
ARG USER_ID
ARG USER_NAME
ARG GROUP_ID
ARG GROUP_NAME

# Make container user
RUN addgroup --system --gid ${GROUP_ID} ${GROUP_NAME}
RUN adduser --system --shell /bin/sh --uid ${USER_ID} --ingroup ${GROUP_NAME} --disabled-password ${USER_NAME}

# Make php-fpm:alpline user
# RUN sed -i "s/listen = 9000/listen = 9002/g" /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -i "s/user = www-data/user = ${USER_NAME}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${GROUP_NAME}/g" /usr/local/etc/php-fpm.d/www.conf


# Setup GD extension
RUN apk add libpng-dev;
# Setup ZIP extension
RUN apk add libzip-dev

# Install PHP extensions
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql
RUN docker-php-ext-install gd && docker-php-ext-enable gd
RUN docker-php-ext-install zip

WORKDIR /var/www/laravel

EXPOSE 9002

USER ${USER_NAME}
