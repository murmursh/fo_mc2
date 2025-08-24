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

# Refresh packwiz
RUN /root/go/bin/packwiz refresh

# Build mrpack
RUN /root/go/bin/packwiz modrinth export -o /usr/share/nginx/html/bs_craft-9.0.0.mrpack

# Copy refreshed mc_pack to nginx html dir
RUN cp -r . /usr/share/nginx/html/

# Copy index.html as well
COPY index.html /usr/share/nginx/html/

# Expose port
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]