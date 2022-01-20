#!/bin/bash

echo "Installing node-exporter"
mkdir -p /node-exporter
cd /node-exporter

DESTDIR=node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}
FILE=${DESTDIR}.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${FILE}
tar -zxvf ${FILE}

echo "Creating data collection dir"
mkdir -p ${COLLECT_DIR}

echo "Make sure scripts are executables"
find ${SCRIPT_DIR} -name "*.sh" -exec chmod +x {} \;
echo "Adding run_dir to cron"
echo "${CRON_SCHEDULE} root run-parts --regex=.*\.sh ${SCRIPT_DIR}" > /etc/cron.d/exporter

run-parts --regex=.*\.sh ${SCRIPT_DIR}

cron -L 4

/node-exporter/${DESTDIR}/node_exporter \
    --web.listen-address="${NODE_EXPORTER_LISTEN_ADDRESS}:${NODE_EXPORTER_LISTEN_PORT}" \
    --collector.disable-defaults \
    --collector.textfile \
    --collector.textfile.directory="$COLLECT_DIR" \
    $@