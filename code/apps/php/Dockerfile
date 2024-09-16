FROM composer:2.7.9 AS composer

WORKDIR /usr/src/app

COPY app/composer.* ./

RUN composer install \
    --ignore-platform-reqs \
    --no-scripts \
    --optimize-autoloader

##########################################################

FROM php:8.3.11-fpm AS base

RUN apt-get update \
    && apt-get install -y \
        zlib1g-dev \
        libzip-dev

RUN docker-php-ext-install pdo_mysql zip

RUN pecl install apcu-5.1.17
RUN docker-php-ext-enable apcu

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /usr/src/app

COPY ./app /usr/src/app

############################################

FROM base AS vendors

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=composer /usr/src/app/vendor   /usr/src/app/vendor

############################################

FROM base AS php

ENV APP_ENV=dev
ENV APP_DEBUG=1

COPY --from=vendors /usr/src/app/vendor  /usr/src/app/vendor
