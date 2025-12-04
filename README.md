# must-gather_gather_metrics

`oc adm must-gather` can now collect metrics from a given cluster

```
oc adm must-gather -- gather_metrics \
--min-time=$(date --date='2 hours ago' +%s%3N) \
--match="{__name__=~\'kube_node_.*\'}"
```

Run the must-gather command within this repo or place a pre collected `must-gather -- gather_metrics` directory into the root of this repo.


Running the launcher will result in the collected data being available via a running container

```
./launcher.sh
```

Browse to localhost:9090 to start querying
