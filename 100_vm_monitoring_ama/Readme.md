# Collecting logs from VMs using AMA agent and Data Collection Rule (DCR)

You shouldn't modify the VM insights DCR. If you need to collect additional data from the monitored machines, such as event logs and security logs, create additional DCRs and associate them with the same machines.
Src: https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable?tabs=arm#vm-insights-dcr


>As per today, AMA agent cannot collect Prometheus metrics from a VM. It is only supported for AKS clusters.
