#!/bin/sh
set -e

echo "eula=true" > eula.txt

exec java -Xmx${MEMORY} -jar fabric-server-launch.jar nogui
