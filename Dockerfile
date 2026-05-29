# lts-alpine / linux/amd64
FROM node@sha256:2bdb65ed1dab192432bc31c95f94155ca5ad7fc1392fb7eb7526ab682fa5bf14 AS builder
WORKDIR /app

# 1. Copy package files first to leverage Docker caching
COPY package*.json .
RUN npm ci

# 2. Copy EVERYTHING else (this preserves your 'src' and 'public' folder structures)
COPY . .

# 3. Run the build
RUN npm run build

# 1.31-alpine-perl / linux/amd64
FROM nginxinc/nginx-unprivileged@sha256:26aa15426f018100219de75eab73e61cd0d4b28d62816e0ce590704a3967c629

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080

# This is the correct CMD for Nginx. It starts the web server 
# and keeps it running in the foreground so the container doesn't exit.
CMD ["nginx", "-g", "daemon off;"]