ARG BUILD_NODE=build/node

FROM $BUILD_NODE as base

# Create app directory
WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

HEALTHCHECK --interval=30s CMD npm run healthcheck

FROM base as pipeline
CMD ["node", "script/pipeline.js"]
