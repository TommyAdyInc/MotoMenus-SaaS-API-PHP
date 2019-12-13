FROM php:7.3.9-fpm-alpine3.10

RUN docker-php-ext-install \
    bcmath \
    exif \
    mbstring \
    mysqli \
    opcache \
    pdo_mysql

# Install GD library.
RUN apk add --no-cache \
    freetype \
    freetype-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libpng \
    libpng-dev \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    && NPROC=$(getconf _NPROCESSORS_ONLN) \
    && docker-php-ext-install -j${NPROC} gd \
    && apk del --no-cache freetype-dev libjpeg-turbo-dev libpng-dev

# If needed, add a custom php.ini configuration.
COPY ./usr/local/etc/php/php.ini /usr/local/etc/php/php.ini

# Ensure `web-user` user exists.
RUN addgroup -g 10000 -S web-user \
    && adduser -u 10000 -D -S -G web-user web-user

# Replace `www-data` user with `web-user` in default www worker pool config.
RUN sed -i "s|www-data|web-user|" /usr/local/etc/php-fpm.d/www.conf

CMD ["php-fpm"]
