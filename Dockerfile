FROM node:20-bullseye

WORKDIR /app
COPY . .

# install build essentials
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

RUN corepack enable
RUN yarn install
RUN yarn workspaces focus twenty-server
RUN yarn nx build twenty-server

EXPOSE 3000
CMD ["yarn", "nx", "start", "twenty-server"]
