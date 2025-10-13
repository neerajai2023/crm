FROM node:20-alpine

WORKDIR /app
COPY . .

RUN corepack enable
RUN yarn install --immutable
RUN yarn workspaces focus twenty-server

# Build server only
RUN yarn nx build twenty-server

EXPOSE 3000
CMD ["yarn", "nx", "start", "twenty-server"]
