# Build Stage
FROM bitnami/node:18 as builder
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy application code
COPY . .

# Final Stage
FROM bitnami/node:18
WORKDIR /app

# Copy built application
COPY --from=builder /app /app

# Set environment and expose port
ENV NODE_ENV="production"
ENV PORT=3000
EXPOSE 3000

# Start application
CMD ["npm", "start"]
