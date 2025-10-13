FROM node:24-bullseye

# ---------- system deps ----------
RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# ---------- yarn / corepack ----------
RUN corepack enable
RUN corepack prepare yarn@4.9.2 --activate

# ---------- install & build ----------
ENV DATABASE_URL=placeholder
ENV REDIS_URL=placeholder
ENV REDIS_TOKEN=placeholder

RUN yarn install
RUN yarn workspaces focus twenty-server
RUN yarn nx build twenty-server

# ---------- runtime ----------
EXPOSE 3000
CMD ["yarn", "nx", "start", "twenty-server"]
