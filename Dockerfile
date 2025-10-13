FROM node:20-bullseye

# ---------- system deps ----------
RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# ---------- yarn / corepack ----------
RUN corepack enable
RUN corepack prepare yarn@4.9.2 --activate

# ---------- install & build ----------
# Add placeholders so build scripts that expect env vars won't fail
ENV DATABASE_URL=postgresql://postgres:Sara@3019@db.hhnvcplahhfvwjvegrfw.supabase.co:5432/postgres
ENV REDIS_URL=https://calm-stallion-14386.upstash.io
ENV REDIS_TOKEN=ATgyAAIncDIwMjIzMjA5NmVlYmE0ZGVkOGM1NjFlYWUxYWI4NDk0MXAyMTQzODY

# Yarn 4 valid install command (no --verbose / no --immutable)
RUN yarn install
RUN yarn workspaces focus twenty-server
RUN yarn nx build twenty-server

# ---------- runtime ----------
EXPOSE 3000
CMD ["yarn", "nx", "start", "twenty-server"]
