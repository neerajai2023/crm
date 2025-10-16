FROM node:24-bullseye

# ---- system deps (incl. libs for canvas/sharp) ----
RUN apt-get update && apt-get install -y \
    python3 make g++ git \
    libcairo2-dev libpango1.0-dev libjpeg62-turbo-dev libgif-dev librsvg2-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# ---- yarn / corepack ----
RUN corepack enable
RUN corepack prepare yarn@4.9.2 --activate

# Use classic node_modules instead of PnP in CI
RUN printf "nodeLinker: node-modules\n" > .yarnrc.yml

ENV DATABASE_URL=postgresql://postgres:Sara@3019@db.hhnvcplahhfvwjvegrfw.supabase.co:5432/postgres
ENV REDIS_URL=https://calm-stallion-14386.upstash.io
ENV REDIS_TOKEN=ATgyAAIncDIwMjIzMjA5NmVlYmE0ZGVkOGM1NjFlYWUxYWI4NDk0MXAyMTQzODY

RUN yarn install
RUN yarn workspaces focus twenty-server

# Nx CLI (use npm global; yarn global is removed)
RUN npm i -g nx@21.3.11

RUN nx build twenty-server

# ---- runtime ----
EXPOSE 3000
CMD ["nx","start","twenty-server"]
