FROM alpine:3.19 as patcher

WORKDIR /app/

RUN apk add --no-cache wget unzip sed

RUN wget https://f005.backblazeb2.com/file/Glitchless/GT_New_Horizons_2.5.1_Server_Java_8.zip -O gtnh.zip &&  \
    unzip gtnh.zip -d gtnh && \
    rm gtnh.zip

COPY server/ gtnh/
RUN rm gtnh/mods/notenoughIDs-1.5.3.jar # Ultramine crash wit not enought ids

RUN sed -i -e 's/B:EnablePollution=true/B:EnablePollution=false/g' gtnh/config/GregTech/GregTech.cfg && \
    sed -i -e 's/B:oilCanBurn=true/B:oilCanBurn=false/g' gtnh/config/buildcraft/main.cfg && \
    sed -i -e 's/B:"Enable Ownership"=true/B:"Enable Ownership"=false/g' gtnh/config/CarpentersBlocks.cfg

FROM lionzxy/multiarch_java

WORKDIR /app/

ENV RCON_PORT=25575 RCON_PASSWORD=DEFAULT
COPY --from=itzg/rcon-cli:latest /rcon-cli /bin/

COPY --from=patcher /app/gtnh /app/
RUN chmod +x /app/startserver.sh

CMD /app/startserver.sh
