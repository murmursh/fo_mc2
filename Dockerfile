FROM nginx:alpine

# Install packwiz
RUN apk add --no-cache go && \
    go install github.com/packwiz/packwiz@latest && \
    apk del go

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Set up server directory
WORKDIR /data

# Copy modpack files
COPY mc_pack/ .

# Add a build argument to force a cache refresh for the following commands
ARG CACHE_BUSTER=1

# Refresh packwiz
RUN /root/go/bin/packwiz refresh

# Build mrpack
RUN /root/go/bin/packwiz modrinth export -o /usr/share/nginx/html/bs_craft-9.0.0.mrpack

# Copy refreshed mc_pack to nginx html dir
COPY ./mc_pack/ /usr/share/nginx/html/

# Copy index.html as well
COPY index.html /usr/share/nginx/html/

# Expose port
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]