FROM lionzxy/multiarch_java

WORKDIR /app/

ENV RCON_PORT=25575 RCON_PASSWORD=DEFAULT

COPY --from=itzg/rcon-cli:latest /rcon-cli ./bin/
COPY . /app/
RUN chmod +x /app/startserver.sh
RUN echo "eula=true" > /app/eula.txt

CMD /app/startserver.sh
