#!/bin/sh

sed -i "s/SECRET_WORLD_SEED/$SECRET_WORLD_SEED/g" ./settings/worlds.yml

java -Xms${MC_RAM} -Xmx${MC_RAM} @java9args.txt -Dfml.queryResult=confirm -jar lwjgl3ify-forgePatches.jar nogui
