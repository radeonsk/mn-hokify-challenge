FROM node:lts-alpine

RUN mkdir -p /app && chown -R node:node /app

WORKDIR /app

COPY package*.json ./
COPY tsconfig.json ./

USER node

RUN npm install

COPY --chown=node:node src/index.ts ./
COPY --chown=node:node .env ./

EXPOSE 8080

CMD [ "npx", "ts-node", "index.ts" ]