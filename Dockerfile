FROM node:24-bullseye

RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN corepack enable
RUN corepack prepare yarn@4.9.2 --activate

# Disable strict peer dependency enforcement (Yarn 4 default)
RUN yarn config set enableStrictPeerDependencies false

ENV DATABASE_URL=placeholder
ENV REDIS_URL=placeholder
ENV REDIS_TOKEN=placeholder

RUN yarn install
RUN yarn workspaces focus twenty-server

RUN yarn global add nx
RUN npx nx build twenty-server

EXPOSE 3000
CMD ["npx", "nx", "start", "twenty-server"]
