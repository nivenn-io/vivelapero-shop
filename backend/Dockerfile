# Multi-stage Dockerfile for Medusa.js backend

# ============================================
# Stage 1: Development
# ============================================
FROM node:20-alpine AS development

WORKDIR /app

# Install dependencies for building native modules
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package*.json ./

# Install dependencies (including dev dependencies)
RUN npm ci

# Copy source code
COPY . .

# Expose ports (API + Admin)
EXPOSE 9000 7001

# Development command (will be overridden by docker-compose)
CMD ["npm", "run", "dev"]

# ============================================
# Stage 2: Builder (for production)
# ============================================
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package*.json ./

# Install dependencies (production only)
RUN npm ci --only=production

# Copy source code
COPY . .

# Build if needed (Medusa may need compilation step)
RUN npm run build || true

# ============================================
# Stage 3: Production
# ============================================
FROM node:20-alpine AS production

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache curl

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S medusa -u 1001

# Copy built application from builder
COPY --from=builder --chown=medusa:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=medusa:nodejs /app/package*.json ./
COPY --from=builder --chown=medusa:nodejs /app .

# Create uploads directory
RUN mkdir -p /app/uploads && chown -R medusa:nodejs /app/uploads

# Switch to non-root user
USER medusa

# Expose API port (Railway will use this)
EXPOSE 9000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:9000/health || exit 1

# Production start command
CMD ["npm", "run", "start"]
