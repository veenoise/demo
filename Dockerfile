FROM node:26-alpine AS builder
WORKDIR /app

# 1. Copy package files first to leverage Docker caching
COPY package*.json .
RUN npm ci

# 2. Copy EVERYTHING else (this preserves your 'src' and 'public' folder structures)
COPY . .

# 3. Run the build
RUN npm run build

FROM nginx:1.31.1-alpine

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# This is the correct CMD for Nginx. It starts the web server 
# and keeps it running in the foreground so the container doesn't exit.
CMD ["nginx", "-g", "daemon off;"]