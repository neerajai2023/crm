FROM node:24-bullseye

# ---- system deps (includes libs for canvas/sharp) ----
RUN apt-get update && apt-get install -y \
    python3 make g++ git \
    libcairo2-dev libpango1.0-dev libjpeg62-turbo-dev libgif-dev librsvg2-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# ---- yarn / corepack ----
RUN corepack enable && corepack prepare yarn@4.9.2 --activate

# Use classic node_modules to avoid PnP issues in CI
RUN printf "nodeLinker: node-modules\n" > .yarnrc.yml

ENV DATABASE_URL=placeholder
ENV REDIS_URL=placeholder
ENV REDIS_TOKEN=placeholder

RUN yarn install

# Nx CLI available on PATH
RUN npm i -g nx@21.3.11

# Build backend
RUN nx build twenty-server

# Run the compiled server directly (no Nx daemon at runtime)
WORKDIR /app/packages/twenty-server

# Ensure the app binds to the external interface and the Koyeb port
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production

# Start the NestJS server from the build output
CMD ["node", "dist/main.js"]
