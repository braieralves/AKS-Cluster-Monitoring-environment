# Script to create AKS with monitoring enabled (Container Insights and Managed Prometheus)
---

Resources created:
* Resource Group
* AKS cluster
* Log Analytics Workspace
* Azure Monitor Workspace
* Azure Managed Grafana
* Enable Container Insights
* Enable Managed Prometheus monitoring
* Connect to Managed Grafana


# How to use this script
---
1 - Access Azure Portal > Cloud Shell > Bash (All necessary tools are available in the cloud shell), or run the command remotely.

2- Run the command bellow t start the deployment:
```
wget https://raw.githubusercontent.com/braieralves/AKS-Cluster-Monitoring-environment/refs/heads/main/aks-monitoring.sh && sed -i -e 's/\r$//' aks-monitoring.sh && az config set extension.dynamic_install_allow_preview=true && az config set extension.use_dynamic_install=yes_without_prompt && bash ./aks-monitoring.sh
```
3 - Provide requested information:
 Name of Resource Group, AKS cluster, Log Analytics Workspace, Azure Monitor Workspace(Managed Prometheus) and Managed Grafana.


 


