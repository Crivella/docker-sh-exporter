FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        cron \
        wget \
        ca-certificates \
        inotify-tools

ENV \
    SCRIPT_DIR="/scripts" \
    COLLECT_DIR="/data" \
    MONITOR_DIR="/backups" \
    CRON_SCHEDULE="*/15 * * * *" \
    SCRIPT_REGEX="^.*\.sh\$" \
    RUN_SCRIPTS_ON_STARTUP="NO" \
    INOTIFY_ENABLE="YES" \
    INOTIFY_LOG_FILE="/data/inotify.log" \
    INOTIFY_FMT="%T %e %w %f" \
    INOTIFY_TIMEFMT="%Y-%m-%d %H:%M:%S %z" \
    INOTIFY_EVENTS="CREATE" \
    INOTIFY_OPTS="-r" \
    EXTRA_INSTALL="" \
    NODE_EXPORTER_VERSION="1.5.0" \
    NODE_EXPORTER_ARCH="linux-amd64" \
    NODE_EXPORTER_LISTEN_ADDRESS="0.0.0.0" \
    NODE_EXPORTER_LISTEN_PORT=9781 

VOLUME ${SCRIPT_DIR}
VOLUME ${MONITOR_DIR}
VOLUME ${COLLECT_DIR}

EXPOSE 9781/tcp

# COPY install-node-exporter.sh /tmp/
# RUN /tmp/install-node-exporter.sh && rm /tmp/install-node-exporter.sh

# CMD /node-exporter/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}/node_exporter \
#     --collector.disable-defaults \
#     --collector.textfile \
#     --collector.textfile.directory="$COLLECT_DIR"

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]