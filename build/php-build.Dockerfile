ARG BASE_PHP=php:8.2-fpm

FROM ${BASE_PHP} AS base

ENV MAKEFLAGS="-j18"

ARG REDIS_VERSION=5.3.7
ARG GRPC_VERSION=1.60.0
ARG PROTOBUF_VERSION=3.21.9
ARG APCU_VERSION=5.1.22

RUN echo foo

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions intl
RUN install-php-extensions zip
RUN install-php-extensions pcntl
RUN install-php-extensions sockets
RUN install-php-extensions sysvshm
RUN install-php-extensions pdo_pgsql
RUN install-php-extensions gd
RUN install-php-extensions calendar

RUN install-php-extensions redis-$REDIS_VERSION
RUN install-php-extensions grpc-$GRPC_VERSION
RUN install-php-extensions protobuf-$PROTOBUF_VERSION
RUN install-php-extensions apcu-$APCU_VERSION
RUN install-php-extensions xdebug
RUN install-php-extensions igbinary

RUN install-php-extensions opcache

RUN docker-php-ext-enable redis
RUN docker-php-ext-enable grpc
RUN docker-php-ext-enable protobuf
RUN docker-php-ext-enable apcu
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-enable igbinary

FROM base AS add-npm

ARG NVM_VERSION=0.40.1
ARG NODEJS_VERSION=18.20.7

ENV NVM_DIR="/usr/local/nvm"

RUN cd  && mkdir -p ${NVM_DIR} \
        && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash 
RUN cd  && . ${NVM_DIR}/nvm.sh \
        && nvm install ${NODEJS_VERSION} \
        && nvm use v${NODEJS_VERSION} \
        && nvm alias default node

ENV PATH="${NVM_DIR}/versions/node/v${NODEJS_VERSION}/bin:${PATH}"

FROM add-npm AS build

COPY --from=composer/composer:lts /usr/bin/composer /usr/bin/composer

RUN apt update && apt install -y git && mkdir -p /etc/ssh && ssh-keyscan -H github.com >>/etc/ssh/ssh_known_hosts

