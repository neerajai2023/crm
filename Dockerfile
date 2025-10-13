FROM node:20-bullseye

WORKDIR /app
COPY . .

RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*
RUN corepack enable
RUN yarn config set network-timeout 600000
# 👇 show full log output
RUN yarn install --verbose
