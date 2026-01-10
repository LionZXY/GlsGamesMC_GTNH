FROM alpine:3.19 as patcher

WORKDIR /app/

RUN apk add --no-cache wget unzip sed

RUN wget https://f003.backblazeb2.com/file/lionzxy-static-files/GT_New_Horizons_2.8.4_Server_Java_17-25.zip -O gtnh.zip &&  \
    unzip gtnh.zip -d gtnh && \
    rm gtnh.zip

COPY server/ gtnh/
 # Ultramine requirements https://github.com/SKProCH/ultramine_core?tab=readme-ov-file#launching-gtnh
RUN rm gtnh/mods/archaicfix-0.7.7.jar && rm gtnh/mods/coretweaks-0.3.3.6-GTNH.jar
RUN rm gtnh/mods/ServerUtilities-2.2.2.jar # Temprorary fix for https://github.com/GTNewHorizons/ServerUtilities/pull/259


RUN sed -i -e 's/B:EnablePollution=true/B:EnablePollution=false/g' gtnh/config/GregTech/GregTech.cfg && \
    sed -i -e 's/B:oilCanBurn=true/B:oilCanBurn=false/g' gtnh/config/buildcraft/main.cfg && \
    sed -i -e 's/B:"Enable Ownership"=true/B:"Enable Ownership"=false/g' gtnh/config/CarpentersBlocks.cfg && \
    sed -i -e 's/B:ForestryStampsAndChunkLoaderCoinsServerEnabled=false/B:ForestryStampsAndChunkLoaderCoinsServerEnabled=true/g' gtnh/config/GTNewHorizons/dreamcraft.cfg && \
    sed -i -e 's/B:MultiBlockMachines.disableMaintenance_false=false/B:MultiBlockMachines.disableMaintenance_false=true/g' gtnh/config/GregTech/MachineStats.cfg

FROM amazoncorretto:21-alpine-full

WORKDIR /app/

ENV RCON_PORT=25575 RCON_PASSWORD=DEFAULT
COPY --from=itzg/rcon-cli:latest /rcon-cli /bin/

COPY --from=patcher /app/gtnh /app/
RUN chmod +x /app/startserver.sh

CMD /app/startserver.sh
