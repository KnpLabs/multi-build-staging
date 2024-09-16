FROM composer:2.7.4 as composer

WORKDIR /opt/php

COPY php/composer.* ./

RUN composer install \
    --ignore-platform-reqs \
    --no-scripts \
    --optimize-autoloader

############################################

FROM base AS vendors

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=composer /opt/php/vendor   /opt/php/vendor

############################################

FROM php:8.3.11-fpm-alpine as php

WORKDIR /opt/php

RUN docker-php-ext-install -j"$(nproc)" intl opcache pcntl pdo_mysql soap sockets sodium zip

RUN useradd docker -d /home/docker -u 1000 && \
    mkdir -p /home/docker/opcache /home/docker/composer /opt/php && \
    chown -R docker:docker /home/docker /opt/php

COPY --from=composer   /usr/bin/composer /usr/local/bin/composer
COPY --from=vendors    /opt/php/vendor   /opt/php/vendor
COPY app               /opt/php

USER docker

CMD ["php-fpm"]

