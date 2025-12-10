#!/bin/bash

#Create tmp 
mkdir -p tmp/

#Get desired PROM_VERSION
echo -n "Insert desired Prometheus version - Openshift 4.18 uses '2.51.1' :"
read PROM_VERSION

#Download the desired PROM_VERSION
curl -Ls https://github.com/prometheus/prometheus/releases/download/v$PROM_VERSION/prometheus-$PROM_VERSION.linux-amd64.tar.gz | tar -xvz -C tmp

#Create configfiles
echo "creating config files..."
mkdir tmp/prometheus-config
touch tmp/prometheus-config/prometheus.yml

#Create tsdb blocks from openmetrics 
echo "creating TSDB blocks...."
tmp/prometheus-$PROM_VERSION.linux-amd64/promtool tsdb create-blocks-from openmetrics must-gather.local.*/quay-io-openshift-*/monitoring/metrics/metrics.openmetrics tmp/prometheus-$PROM_VERSION.linux-amd64/data/

#Launch the container
echo "launching the Prometheus instance..."
podman run --rm -p 9090:9090/tcp -v $PWD/tmp/prometheus-$PROM_VERSION.linux-amd64/data:/prometheus:U,Z --privileged quay.io/prometheus/prometheus:v$PROM_VERSION --storage.tsdb.path=/prometheus --config.file=/dev/null
