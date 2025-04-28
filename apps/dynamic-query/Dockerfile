ARG BASE='build/node22'
FROM ${BASE} AS api

WORKDIR /app

COPY package*.json ./

RUN --mount=type=secret,id=NPM_TOKEN \
    --mount=type=cache,id=npm-cache,target=/root/.npm \
    npm  config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) && npm whoami
RUN --mount=type=cache,id=npm-cache,target=/root/.npm \
    npm ci

USER node
COPY . .
EXPOSE 3000

CMD ["npm", "start"]
# CMD ["npm", "run", "dev"]