# Use Node 20 LTS image
FROM node:20-alpine

# Create and switch to app directory
WORKDIR /app

# Copy everything
COPY . .

# Install Yarn 4 and build only the server package
RUN corepack enable \
 && yarn install --immutable \
 && yarn build twenty-server

# Expose API port
EXPOSE 3000

# Start the server
CMD ["npx", "nx", "start", "twenty-server"]
