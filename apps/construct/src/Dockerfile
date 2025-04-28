ARG BUILD_PHP

FROM $BUILD_PHP AS build

COPY ./composer.json /app/
COPY ./composer.lock /app/
COPY ./libs /libs
WORKDIR /app

RUN --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    composer install --no-interaction --no-dev --no-ansi --no-progress --ignore-platform-reqs --prefer-source -vv 


ARG MATHJAX_VERSION="2.6.1"

RUN curl -L "https://github.com/mathjax/MathJax/archive/$MATHJAX_VERSION.tar.gz" | tar --strip-components=1 -xz -C "/app/taoQtiItem/views/js/mathjax"
COPY ./index.php /app/

FROM scratch AS export
COPY --link --from=build  /app/ /app
