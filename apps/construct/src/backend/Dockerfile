ARG APP_CONSTRUCT

ARG BASE

FROM $APP_CONSTRUCT AS app-construct

FROM $BASE AS base
ARG TARGETARCH

RUN <<EOC
    set +e
    useradd -d /app -s /bin/bash  -u 1000 -U tao
    mkdir -p /data/construct/{config,data,locales}
    chown -R tao:tao /data/construct

    apt update && apt install -y gosu supervisor

EOC

ADD --chmod=0755 https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-${TARGETARCH} /usr/local/bin/supercronic

COPY --link --from=app-construct --chown=1000:1000 /app /app/construct

VOLUME [ "/data" ]
RUN <<EOC
    set +e

    rm -rf \
        /app/construct/tao/views/locales \
        /app/construct/config \
        /app/construct/data

    # mkdir -p /app/construct/tao/views

    ln -s /data/construct/config  /app/construct/
    ln -s /data/construct/data    /app/construct/
    ln -s /data/construct/locales /app/construct/tao/views/
EOC

ENV TAOADM_CONFIG=/usr/local/etc/tao
ENV TAOADM_LIBEXEC=/usr/local/libexec/tao
ENV TAOADM_BIN=/usr/local/sbin/taoadm

WORKDIR /app

COPY ./config ${TAOADM_CONFIG}
COPY ./libs ${TAOADM_LIBEXEC}
ADD --chmod=0755 ./taoadm ${TAOADM_BIN}
USER root

ENTRYPOINT [ "taoadm" ]
CMD [ "run" ]