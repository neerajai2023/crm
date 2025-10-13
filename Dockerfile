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

# 👇 Install nx CLI globally so it’s available in PATH
RUN yarn global add nx

# 👇 Or explicitly run Nx from node_modules
RUN npx nx build twenty-server

EXPOSE 3000
CMD ["npx", "nx", "start", "twenty-server"]
