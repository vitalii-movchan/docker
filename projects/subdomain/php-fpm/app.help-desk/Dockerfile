FROM php:fpm-alpine

# Get any build argument overrides
ARG USER_ID
ARG USER_NAME
ARG GROUP_ID
ARG GROUP_NAME
ARG LISTEN_PORT

# Make container user
RUN addgroup --system --gid ${GROUP_ID} ${GROUP_NAME}
RUN adduser --system --shell /bin/sh --uid ${USER_ID} --ingroup ${GROUP_NAME} --disabled-password ${USER_NAME}
# Make php-fpm:alpline user
RUN sed -i "s/user = www-data/user = ${USER_NAME}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${GROUP_NAME}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/listen = 9000/listen = 9001/g" /usr/local/etc/php-fpm.d/zz-docker.conf

# Get latest Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/app.help-desk

EXPOSE 9001

USER ${USER_NAME}
