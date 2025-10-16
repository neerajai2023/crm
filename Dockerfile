ENV DATABASE_URL=postgresql://postgres:Sara@3019@db.hhnvcplahhfvwjvegrfw.supabase.co:5432/postgres
ENV REDIS_URL=https://calm-stallion-14386.upstash.io
ENV REDIS_TOKEN=ATgyAAIncDIwMjIzMjA5NmVlYmE0ZGVkOGM1NjFlYWUxYWI4NDk0MXAyMTQzODY

# install everything at the repo root (no focus/pruning)
RUN yarn install

# make nx available in PATH
RUN npm i -g nx@21.3.11

# build the backend
RUN nx build twenty-server

EXPOSE 3000
CMD ["nx","start","twenty-server"]
