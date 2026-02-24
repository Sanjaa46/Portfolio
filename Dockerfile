# Stage 1: Build Tailwind CSS
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy source files
COPY . .

# Build the CSS
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy built assets and HTML from builder
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/assets /usr/share/nginx/html/assets/

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]