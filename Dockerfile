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

# ---- resolve build output at build-time and symlink it ----
RUN set -e; \
  if [ -f /app/packages/twenty-server/dist/main.js ]; then \
    ln -sf /app/packages/twenty-server/dist/main.js /app/run.js; \
  elif [ -f /app/packages/twenty-server/dist/src/main.js ]; then \
    ln -sf /app/packages/twenty-server/dist/src/main.js /app/run.js; \
  elif [ -f /app/dist/packages/twenty-server/main.js ]; then \
    ln -sf /app/dist/packages/twenty-server/main.js /app/run.js; \
  elif [ -f /app/dist/apps/twenty-server/main.js ]; then \
    ln -sf /app/dist/apps/twenty-server/main.js /app/run.js; \
  else \
    echo "Could not find built server entry (main.js). Listing candidates:" >&2; \
    find /app -maxdepth 6 -type f -name main.js >&2; \
    exit 1; \
  fi

ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production

EXPOSE 3000
CMD ["node","/app/run.js"]


