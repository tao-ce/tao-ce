ARG BUILD_NODE=build/node

FROM $BUILD_NODE as base

FROM base as backend

WORKDIR /app

COPY package*.json ./

RUN npm ci && npm cache clean --force

COPY . .

EXPOSE 3001

CMD ["node", "src/index.js"]
