FROM node:22.14.0-alpine AS base

FROM base AS deps
WORKDIR /build
COPY package.json .
RUN npm install

FROM base AS build
WORKDIR /build
COPY --from=deps /build/node_modules ./node_modules
COPY . .
RUN npm run build

FROM base
EXPOSE 3000
WORKDIR /app
COPY --from=deps /build/node_modules ./node_modules
COPY --from=build /build/build ./build
COPY --from=build /build/package.json ./package.json
ENTRYPOINT ["npm", "run", "start"]
