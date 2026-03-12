FROM php:8.2-fpm-alpine

# uname -m
ENV LD_LIBRARY_PATH=/usr/glibc-compat/sbin/ldconfig
# ENV LD_LIBRARY_PATH=/usr/glibc-compat/lib
# ENV LD_PRELOAD=/lib/ld-linux-x86-64.so.2

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

RUN apk update && apk upgrade

# Linux GNU C++ Libraries
# apk add --no-cache postgresql-client bash openssl libgcc libstdc++ ncurses-libs
# apk add --no-cache libaio libnsl libc6-compat libstdc++
RUN apk add --no-cache gcc
RUN apk add --no-cache libgcc libc6-compat libstdc++

# https://github.com/sgerrand/alpine-pkg-glibc
# https://ftp.gnu.org/gnu/glibc/glibc-2.2.5.tar.gz
# See usr/lib
RUN apk del gcompat

WORKDIR /tmp

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-dev-2.34-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-bin-2.34-r0.apk

# RUN apk add gcompat
# apk info glibc
# RUN apk add --allow-untrust --force-overwrite glibc-2.34-r0.apk
# RUN apk add --allow-untrust --force-overwrite glibc-dev-2.34-r0.apk
# RUN apk add --allow-untrust --force-overwrite glibc-bin-2.34-r0.apk

# Utils Libraries
RUN apk add --no-cache nano

# Setup ODBC driver manager
# dpkg -L unixodbc-dev
RUN apk add --no-cache --virtual .php-build-dependencies unixodbc-dev

# Extract PHP extensions source
# See /usr/src/php
RUN docker-php-source extract

# Fix ODBC extenison
# https://github.com/docker-library/php/issues/103#issuecomment-271413933
RUN sed -i '1s/^/# https:\/\/github.com\/docker-library\/php\/issues\/103#issuecomment-271413933 \n/' /usr/src/php/ext/odbc/config.m4
RUN sed -i '2s/^/AC_DEFUN([PHP_ALWAYS_SHARED],[])dnl \n/' /usr/src/php/ext/odbc/config.m4
RUN sed -i '3s/^/\n /' /usr/src/php/ext/odbc/config.m4

# Configure PHP extensions
RUN docker-php-ext-configure odbc --with-unixODBC=shared,/usr
RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr

# Install PHP extensions
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

RUN docker-php-ext-install odbc && docker-php-ext-enable odbc
RUN docker-php-ext-install pdo_odbc && docker-php-ext-enable pdo_odbc

# Delete PHP extensions source
RUN docker-php-source delete

# Linux GNU C++ Libraries

# https://www.vertica.com/download/vertica/client-drivers/
# https://packagist.org/packages/rezon73/dbal-vertica-driver
# https://docs.vertica.com/23.4.x/en/connecting-to/client-libraries/client-drivers/install-config/odbc/creating-an-odbc-data-source-name-dsn/creating-an-odbc-dsn-linux/
# https://dev.to/bitecode/how-to-get-glibc-version-c-lang-26he
# Download official Vertica ODBC driver
# RUN curl -OL https://www.vertica.com/client_drivers/12.0.x/12.0.4-0/vertica-client-12.0.4-0.x86_64.tar.gz
RUN curl -OL https://www.vertica.com/client_drivers/10.0.x/10.0.1-0/vertica-client-10.0.1-0.x86_64.tar.gz

# Extract & install it
# RUN tar -xvzf vertica-client-12.0.4-0.x86_64.tar.gz -C /
RUN tar -xvzf vertica-client-10.0.1-0.x86_64.tar.gz -C /

# Set config files
RUN echo '[VerticaDev]' >> /etc/odbc.ini
RUN echo 'Description = Vertica ODBC Database' >> /etc/odbc.ini
RUN echo 'Driver = Vertica' >> /etc/odbc.ini

# https://blog.csdn.net/qq_40460909/article/details/134679482
# ldd /opt/vertica/lib64/libverticaodbc.so
# ldconfig /opt/vertica/lib64/libverticaodbc.so
# objdump --dynamic-syms /opt/vertica/lib64/libverticaodbc.so | grep GLIB
# readelf -d  /opt/vertica/lib64/libverticaodbc.so
# ls -ld /lib/libresolv.so.2
RUN echo '[Vertica]' >> /etc/odbcinst.ini
RUN echo 'Description = Vertica ODBC Driver' >> /etc/odbcinst.ini
RUN echo 'Driver = /opt/vertica/lib64/libverticaodbc.so' >> /etc/odbcinst.ini

# ldd /usr/lib/libodbcinst.so
# ldconfig /usr/lib/libodbcinst.so
RUN echo '[Driver]' >> /etc/vertica.ini
RUN echo 'DriverManagerEncoding = UTF-16' >> /etc/vertica.ini
RUN echo 'ODBCInstLib = /usr/lib/libodbcinst.so' >> /etc/vertica.ini
RUN echo 'ErrorMessagesPath = /opt/vertica/lib64' >> /etc/vertica.ini
RUN echo 'LogLevel=/tmp' >> /etc/vertica.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/nux-game

EXPOSE 9000

USER ${USER_NAME}

