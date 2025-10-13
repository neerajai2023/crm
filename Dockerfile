FROM node:20-alpine

# Add build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app
COPY . .

RUN corepack enable
# 🔽 remove the --immutable flag
RUN yarn install
RUN yarn workspaces focus twenty-server
RUN yarn nx build twenty-server

EXPOSE 3000
CMD ["yarn", "nx", "start", "twenty-server"]
