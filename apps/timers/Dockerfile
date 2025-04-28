ARG BUILD='build/node'
ARG BASE='build/node'
FROM ${BUILD} AS export

WORKDIR /app

COPY . .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm \
    npm ci && npm run build

CMD ["node", "dist/index.js"]