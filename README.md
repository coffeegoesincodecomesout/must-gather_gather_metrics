# must-gather_gather_metrics

`oc adm must-gather` can now collect metrics from a given cluster:
 - This feature is available from 4.18 +

Run the must-gather command within this repo or place a pre collected must-gather -- gather_metrics directory into the root of this repo.

etcd dashboard:
```
oc adm must-gather -- gather_metrics \
--min-time=$(date --date='2 hours ago' +%s%3N) \
--match="{__name__=~\'etcd_.*\'}" \
--match="ALERTS{alertname=~\'.*[Ee]tcd.*\'}" \
--match="prometheus_build_info"
```

API performance dashboard:
```
oc adm must-gather -- gather_metrics \
--min-time=$(date --date='2 hours ago' +%s%3N) \
--match="{__name__=~\'apiserver_.*\'}" \
--match="ALERTS{alertname=~\'.*[Aa]pi[Ss]erver.*|.*[Kk]ube[Aa]pi.*\'}" \
--match="prometheus_build_info"
```

Cluster USE method dashboard:
```
oc adm must-gather -- gather_metrics \
--min-time=$(date --date='2 hours ago' +%s%3N) \
--match="{__name__=~\'kube_pod_.*\'}" \
--match="{__name__=~\'kube_node_.*\'}" \
--match="{__name__=~\'kube_persistentvolume.*\'}" \
--match="{__name__=~\'container_cpu_cfs_.*\'}" \
--match="{__name__=~\'kubelet_volume_stats_.*\'}" \
--match="ALERTS{alertname=~\'.*[Kk]ube.*|.*[Cc]luster.*\'}" \
--match="prometheus_build_info"
```

Node USE method dashboard:
```
oc adm must-gather -- gather_metrics \
--min-time=$(date --date='2 hours ago' +%s%3N) \
--match="{__name__=~\'node_cpu_.*\'}" \
--match="{__name__=~\'node_load.*\'}" \
--match="{__name__=~\'node_memory_.*\'}" \
--match="node_vmstat_pgmajfault" \
--match="{__name__=~\'node_disk_.*\'}" \
--match="{__name__=~\'node_network_.*\'}" \
--match="ALERTS{alertname=~\'.*[Nn]ode.*\'}" \
--match="prometheus_build_info"
```

Networking dashboard:
```
oc adm must-gather -- gather_metrics \
--min-time=$(date --date='2 hours ago' +%s%3N) \
--match="{__name__=~\'node_network_.*\'}" \
--match="{__name__=~\'ovnkube_.*\'}" \
--match="{__name__=~\'coredns_.*\'}" \
--match="ALERTS{alertname=~\'.*[Nn]etwork.*|.*[Oo][Vv][Nn].*|.*[Cc]ore[Dd][Nn][Ss].*|.*[Dd][Nn][Ss].*\'}" \
--match="prometheus_build_info"
```

Loki dashboard:
```
oc adm must-gather -- gather_metrics \
--min-time=$(date --date='2 hours ago' +%s%3N) \
--match="{__name__=~\'loki_.*\'}" \
--match="ALERTS{alertname=~\'.*[Ll]oki.*\'}" \
--match="prometheus_build_info"
```

Prometheus overview dashboard:
```
oc adm must-gather -- gather_metrics \
--min-time=$(date --date='2 hours ago' +%s%3N) \
--match="{__name__=~\'prometheus_.*\'}" \
--match="{__name__=~\'scrape_.*\'}" \
--match="up" \
--match="ALERTS{alertname=~\'.*[Pp]rometheus.*\'}" \
--match="prometheus_build_info"
```

Running the launcher will result in the collected data being available via a running container

```
./launcher.sh
```

Browse to http://localhost:9090 to start querying
