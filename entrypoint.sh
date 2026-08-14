#!/bin/sh
set -e

# Accept the Minecraft EULA (https://www.minecraft.net/en-us/eula), the
# server refuses to start without this
echo "eula=true" > eula.txt

# Start the Fabric server with the configured memory allocation
exec java -Xmx${MEMORY} -jar fabric-server-launch.jar nogui