#!/usr/bin/env bash
set -e

echo "eula=true" > eula.txt

exec java -Xmx2G -jar /server/fabric-server-launch.jar nogui