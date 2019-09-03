FROM php:7.3.9-fpm-alpine3.10

RUN docker-php-ext-install \
    bcmath \
    exif \
    mbstring \
    mysqli \
    opcache \
    pdo_mysql

# If needed, add a custom php.ini configuration.
COPY ./usr/local/etc/php/php.ini /usr/local/etc/php/php.ini

# Ensure `web-user` user exists.
RUN addgroup -g 10000 -S web-user \
    && adduser -u 10000 -D -S -G web-user web-user

# Replace `www-data` user with `web-user` in default www worker pool config.
RUN sed -i "s|www-data|web-user|" /usr/local/etc/php-fpm.d/www.conf

CMD ["php-fpm"]
