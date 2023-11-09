FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        cron \
        wget \
        ca-certificates

ENV \
    SCRIPT_DIR="/scripts" \
    COLLECT_DIR="/data" \
    MONITOR_DIR="/backups" \
    CRON_SCHEDULE="*/15 * * * *" \
    SCRIPT_REGEX="^.*\.sh\$" \
    RUN_SCRIPTS_ON_STARTUP="NO" \
    EXTRA_INSTALL="" \
    NODE_EXPORTER_VERSION="1.5.0" \
    NODE_EXPORTER_ARCH="linux-amd64" \
    NODE_EXPORTER_LISTEN_ADDRESS="0.0.0.0" \
    NODE_EXPORTER_LISTEN_PORT=9781 

VOLUME ${SCRIPT_DIR}
VOLUME ${COLLECT_DIR}

EXPOSE 9781/tcp

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]