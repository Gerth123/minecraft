# This is the base image of our application image
FROM ubuntu:22.04
 
# Prevents apt-get from asking interactive questions during the build
ENV DEBIAN_FRONTEND=noninteractive
 
# Install Java (needed to run the Minecraft server), curl (needed to
# download it), and ca-certificates (needed so curl trusts HTTPS downloads)
RUN apt-get update && apt-get install -y openjdk-17-jre-headless curl ca-certificates
 
# This is a special directory variable, used to encapsulate
# all server specific files and assets in a separate folder on the system
WORKDIR /server
 
# Download the Fabric installer and use it to install the Fabric server
RUN curl -o fabric-installer.jar "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.3/fabric-installer-1.0.3.jar" \
    && java -jar fabric-installer.jar server -mcversion 1.20.1 -loader 0.19.3 -downloadMinecraft
 
# Accept the Minecraft EULA (https://www.minecraft.net/en-us/eula)
RUN echo "eula=true" > eula.txt
 
# Default value for the memory setting, can be overridden via
# docker-compose.yaml
ENV MEMORY=2G
 
# This is the port the Minecraft server listens on
EXPOSE 25565
 
# This is the command that will be executed on container launch
CMD ["sh", "-c", "exec java -Xmx${MEMORY} -jar fabric-server-launch.jar nogui"]