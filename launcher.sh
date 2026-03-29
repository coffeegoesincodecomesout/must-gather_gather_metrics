#!/bin/bash

#Create tmp 
mkdir -p tmp/

#Set Prom version
PROM_VERSION=""

#Try to get the Prometheus version from the dump
PROM_VERSION=`grep prometheus_build_info must-gather.local.*/quay-io-openshift-release-*/monitoring/metrics/metrics.openmetrics | head -n 1 | sed -n 's/.*version="\([^"]*\)".*/\1/p'` 

echo $PROM_VERSION

#Get desired PROM_VERSION
if [ -z "$PROM_VERSION" ]; then
  echo "Insert desired Prometheus version - Openshift 4.18 uses '2.51.1' :"
  read PROM_VERSION
fi

#Download the desired PROM_VERSION
curl -Ls https://github.com/prometheus/prometheus/releases/download/v$PROM_VERSION/prometheus-$PROM_VERSION.linux-amd64.tar.gz | tar -xvz -C tmp

#Create configfiles
echo "creating config files..."
mkdir tmp/prometheus-config
touch tmp/prometheus-config/prometheus.yml

#Create tsdb blocks from openmetrics 
echo "creating TSDB blocks...."
tmp/prometheus-$PROM_VERSION.linux-amd64/promtool tsdb create-blocks-from openmetrics must-gather.local.*/quay-io-openshift-*/monitoring/metrics/metrics.openmetrics tmp/prometheus-$PROM_VERSION.linux-amd64/data/

#Launch Prometheus in the background
echo "launching the Prometheus instance..."
PROM_CONTAINER=$(podman run --rm -d -p 9090:9090/tcp -v $PWD/tmp/prometheus-$PROM_VERSION.linux-amd64/data:/prometheus:U,Z --privileged quay.io/prometheus/prometheus:v$PROM_VERSION --storage.tsdb.path=/prometheus --config.file=/dev/null)
echo "Prometheus running (container: $PROM_CONTAINER)"
echo "Browse Prometheus at http://localhost:9090"

#Stop Prometheus when the script exits
trap "echo 'stopping Prometheus...'; podman stop $PROM_CONTAINER" EXIT

#Launch Perses (foreground)
echo "launching Perses..."
echo "Browse Perses at http://localhost:8080"
mkdir -p perses/data
podman run --rm --network=host \
  -v $PWD/perses/config.yaml:/etc/perses/config.yaml:Z \
  -v $PWD/perses/provisioning:/etc/perses/provisioning:Z \
  -v $PWD/perses/data:/var/lib/perses:U,Z \
  persesdev/perses \
  --config=/etc/perses/config.yaml
