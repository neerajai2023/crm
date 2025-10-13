FROM node:24-bullseye

# ---------- system deps ----------
RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# ---------- yarn / corepack ----------
RUN corepack enable
RUN corepack prepare yarn@4.9.2 --activate

# ---------- install & build ----------
# Yarn 4 now uses rc files rather than the "config set" CLI for global flags.
# So we add the setting via environment variable instead:
ENV YARN_ENABLE_STRICT_PEER_DEPENDENCIES=false

ENV DATABASE_URL=postgresql://postgres:Sara@3019@db.hhnvcplahhfvwjvegrfw.supabase.co:5432/postgres
ENV REDIS_URL=https://calm-stallion-14386.upstash.io
ENV REDIS_TOKEN=ATgyAAIncDIwMjIzMjA5NmVlYmE0ZGVkOGM1NjFlYWUxYWI4NDk0MXAyMTQzODY

RUN yarn install
RUN yarn workspaces focus twenty-server

RUN yarn global add nx
RUN npx nx build twenty-server

# ---------- runtime ----------
EXPOSE 3000
CMD ["npx", "nx", "start", "twenty-server"]
