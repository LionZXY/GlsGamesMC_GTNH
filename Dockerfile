FROM lionzxy/multiarch_java

WORKDIR /app/

RUN apk add sed

COPY . /app/
RUN chmod +x /app/startserver.sh
RUN echo "eula=true" > /app/eula.txt

CMD /app/startserver.sh
