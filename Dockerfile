FROM debian:buster

RUN apt-get update
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        cron \
        wget \
        ca-certificates 

ENV \
    SCRIPT_DIR="/scripts" \
    COLLECT_DIR="/data" \
    CRON_SCHEDULE="*/5 * * * *" \
    NODE_EXPORTER_VERSION="1.3.1" \
    NODE_EXPORTER_ARCH="linux-amd64" \
    NODE_EXPORTER_LISTEN_ADDRESS="0.0.0.0" \
    NODE_EXPORTER_LISTEN_PORT=9781 

VOLUME ${SCRIPT_DIR}

EXPOSE 9781/tcp

# COPY install-node-exporter.sh /tmp/
# RUN /tmp/install-node-exporter.sh && rm /tmp/install-node-exporter.sh

# CMD /node-exporter/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}/node_exporter \
#     --collector.disable-defaults \
#     --collector.textfile \
#     --collector.textfile.directory="$COLLECT_DIR"

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]