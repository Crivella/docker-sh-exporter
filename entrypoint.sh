#!/bin/bash

EXTRA_INSTALL=`echo ${EXTRA_INSTALL} | tr -s "," " "`
apt-get update && apt-get install -y --no-install-recommends ${EXTRA_INSTALL} 

DESTDIR=node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}
if [ ! -e /node-exporter/${DESTDIR}/node_exporter ]; then
    echo "Installing node-exporter"
    mkdir -p /node-exporter
    cd /node-exporter

    FILE=${DESTDIR}.tar.gz
    wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${FILE}
    tar -zxvf ${FILE}
fi

echo "Creating data collection dir"
mkdir -p ${COLLECT_DIR}

echo "Make sure scripts are executables"
find ${SCRIPT_DIR} -regex "${SCRIPT_REGEX}" -exec chmod +x {} \;
echo "Adding run_dir to cron"
echo "${CRON_SCHEDULE} root run-parts --regex=${SCRIPT_REGEX} ${SCRIPT_DIR}" > /etc/cron.d/exporter

if [[ "${RUN_SCRIPTS_ON_STARTUP^^l}" == "yes" ]]; then
    echo "Running scripts on startup..."
    run-parts --test --regex=${SCRIPT_REGEX} ${SCRIPT_DIR}
    run-parts --regex=${SCRIPT_REGEX} ${SCRIPT_DIR}
fi
if [[ "${INOTIFY_ENABLE^^l}" == "yes" ]]; then
    echo "Starting inotifywait daemon..."
    INOTIFY_EVENTS="`echo ${INOTIFY_EVENTS} | tr -s "," " "`"
    OPT=""
    for e in ${INOTIFY_EVENTS}; do
        OPT+="-e ${e^^} "
    done
    inotifywait -m -r -d -o ${INOTIFY_LOG_FILE} --format "${INOTIFY_FMT}" --timefmt "${INOTIFY_TIMEFMT}" ${OPT} ${MONITOR_DIR}
fi

echo "Starting cron daemon..."
cron -L 4

echo "Starting node exporter..."
/node-exporter/${DESTDIR}/node_exporter \
    --web.listen-address="${NODE_EXPORTER_LISTEN_ADDRESS}:${NODE_EXPORTER_LISTEN_PORT}" \
    --collector.disable-defaults \
    --collector.textfile \
    --collector.textfile.directory="$COLLECT_DIR" \
    $@