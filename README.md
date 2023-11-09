# docker-sh-exporter

This container makes use of the `--collector.textfile` of [node exporter](https://github.com/prometheus/node_exporter) to create a custom [prometheus](https://prometheus.io/) exporter for monitoring files inside a directory.

## Typical use-case

Monitoring files timestamps/sizes in a mounted volume that is used for periodic backups

## Instructions

By default all exporters of `node_exporter` but the `textfile` one are disabled.
The docker command can be used to re-enable specific collectors on a case-by-case basis

### Installation

docker pull crivella1/docker-sh-exporter

### Build

    docker build -t crivella1/docker-sh-exporter 

### Run

    NOTE: Path set to `BACKUP_DIR` variable and mounted volume should match

    docker run --name sh-exporter -v HOST_MONITOR_DIR:MONITOR_DIR -v HOST_SCRIPT_DIR:/scripts -c HOST_COLLECT_DIR:COLLECT_DIR -p XXXXX:9781  -h docker-sh-exporter -t crivella1/docker-sh-exporter

## Container ports

| Container Port | Usage |
| --- | --- |
| 9781 | Ports used for node-exporter to serve the metrics |

## Variables

| Variable | Values | Usage |
| --- | --- | --- |
| `SCRIPT_DIR` | `/scripts` | Location of the mounted volume containing cron scripts to be periodically executed inside the container |
| `COLLECT_DIR`| `/data` | Location inside the container of the data collection dirs where the `.prom` files produced by the scripts should be stored |
| `MONITOR_DIR` | `/backups` | Location of the mounted volume containing the files to be monitored |
| `CRON_SCHEDULE` | `*/15 * * * ` | The schedule with which the cron scripts will be executed |
| `SCRIPT_REGEX` | `^.*\.sh\$` | Regex matching scripts inside $SCRIPT_DIR |
| `RUN_SCRIPTS_ON_STARTUP` | `NO[YES]` | Whether to execute the scripts once at container startup |
| `EXTRA_INSTALL` |  | SPACE separated list of apt packages to be installed at container startup (eg if some custom scripts depends on packages that are not installed by default) |

| `NODE_EXPORTER_VERSION` | `1.5.0` | The version of node_exporter that will be installed the first time the container is launched (Must be a number [github release version number](https://github.com/prometheus/node_exporter/releases)) |
| `NODE_EXPORTER_ARCH` | `linux-amd64` | The system architecture (decides which arch version of node_exporter is installed) |
| `NODE_EXPORTER_LISTEN_ADDRESS` | `0.0.0.0` | The address from which node_exporter will listen to GET requests (0.0.0.0 == ALL) |
| `NODE_EXPORTER_LISTEN_PORT` | `9781` | The port from which node_exporter will listen to GET requests |
