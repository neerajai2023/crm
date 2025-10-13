FROM node:20-bullseye

# ---------- system deps ----------
RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# ---------- yarn / corepack ----------
RUN corepack enable

# optional: make sure Corepack uses Yarn 4 explicitly
RUN corepack prepare yarn@4.9.2 --activate

# ---------- install & build ----------
# Add placeholder envs so build scripts that expect them won't fail
ENV DATABASE_URL=placeholder
ENV REDIS_URL=placeholder
ENV REDIS_TOKEN=placeholder

# Perform the install with detailed logs
RUN yarn install --check-cache --verbose || yarn install --verbose
RUN yarn workspaces focus twenty-server
RUN yarn nx build twenty-server

# ---------- runtime ----------
EXPOSE 3000
CMD ["yarn", "nx", "start", "twenty-server"]
