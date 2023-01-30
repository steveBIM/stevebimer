FROM node:lts-alpine as deps
WORKDIR /opt
RUN apk update && \
    apk add git && \
    git clone --depth=1 https://github.com/transitive-bullshit/nextjs-notion-starter-kit.git && \
    cd nextjs-notion-starter-kit && \
    yarn install --frozen-lockfile && \
    yarn add @waline/client && \
    yarn add sass

FROM node:lts-alpine as builder
ENV NODE_ENV=production
WORKDIR /opt/app
COPY --from=deps /opt/nextjs-notion-starter-kit/ ./
COPY overrides/ ./
RUN yarn build

FROM node:lts-alpine as runner
ENV NODE_ENV=production
WORKDIR /opt/app
COPY --from=builder /opt/app/ ./
EXPOSE 3000
CMD [ "yarn", "start" ]
