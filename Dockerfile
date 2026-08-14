# This is the base image of our application image
FROM eclipse-temurin:17-jre-alpine

# Install curl (needed to download the Fabric installer) and ca-certificates
RUN apk add --no-cache curl ca-certificates

# This is a special directory variable, used to encapsulate
# all server specific files and assets in a separate folder on the system
WORKDIR /server

# Download the Fabric installer and use it to install the Fabric server
RUN curl -o fabric-installer.jar "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.3/fabric-installer-1.0.3.jar" \
    && java -jar fabric-installer.jar server -mcversion 1.20.1 -loader 0.19.3 -downloadMinecraft \
    && rm fabric-installer.jar

# Copy the startup script into the container, this handles EULA acceptance
# and server configuration at runtime
COPY entrypoint.sh /server/entrypoint.sh
RUN chmod +x /server/entrypoint.sh

# Default value for the memory setting, can be overridden via
# docker-compose.yaml or .env
ENV MEMORY=2G

# This is the port the Minecraft server listens on
EXPOSE 25565

# This is the command that will be executed on container launch
ENTRYPOINT ["/server/entrypoint.sh"]