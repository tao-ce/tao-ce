
ARG BUILD='build/node'
ARG BASE='build/node'
FROM ${BUILD} AS export

WORKDIR /app

COPY ./backend .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm \
    npm ci
# COPY ./files/tools /opt/tools

CMD ["node", "./index.js"]