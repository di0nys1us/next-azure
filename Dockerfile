FROM node:alpine as node

FROM node as builder

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn --frozen-lockfile --non-interactive

COPY . .

RUN yarn build

FROM node as runtime

WORKDIR /app

COPY --from=builder /app/package.json .
COPY --from=builder /app/yarn.lock .

RUN yarn --frozen-lockfile --non-interactive

COPY --from=builder /app/.next .next
COPY --from=builder /app/public public

EXPOSE 3000

CMD yarn start
