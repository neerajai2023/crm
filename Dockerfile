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

# ---- runtime ----
# tiny launcher that finds the built main.js wherever Nx put it
RUN printf '#!/bin/sh\nset -e\nexport HOST=${HOST:-0.0.0.0}\nexport PORT=${PORT:-3000}\n# try common Nx output locations\nif [ -f /app/packages/twenty-server/dist/main.js ]; then\n  exec node /app/packages/twenty-server/dist/main.js\nelif [ -f /app/dist/packages/twenty-server/main.js ]; then\n  exec node /app/dist/packages/twenty-server/main.js\nelif [ -f /app/dist/apps/twenty-server/main.js ]; then\n  exec node /app/dist/apps/twenty-server/main.js\nelse\n  echo \"Could not find built server entry (main.js). Searching...\" >&2\n  find /app -maxdepth 4 -type f -name main.js || true\n  exit 1\nfi\n' > /app/start.sh && chmod +x /app/start.sh

EXPOSE 3000
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production
CMD ["/app/start.sh"]
