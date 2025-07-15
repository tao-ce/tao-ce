ARG BUILD='build/node22'

FROM ${BUILD} AS backend

WORKDIR /app

COPY ./package*.json .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm \
    npm ci

COPY . .

CMD ["npm", "start"]
