# syntax=docker/dockerfile-upstream:master-labs

ARG APP_CONSTRUCT
ARG BASE_CADDY

FROM $APP_CONSTRUCT AS app-construct

FROM scratch AS app-construct-clean

COPY --parents --from=app-construct /app/**/views /

# FROM  caddy:2-alpine AS ingress
FROM $BASE_CADDY AS ingress

COPY --from=app-construct-clean /app /srv/static/construct