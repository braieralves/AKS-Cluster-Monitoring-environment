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

# Optional
---

ConfigMap "_container-azm-ms-agentconfig.yaml_" (ama-logs) automatically applied in the end of enviroment created.

Clone the repository _AKS-Cluster---Monitoring-environment_, edit the file _aks-monitoring.sh_, uncomment the line below and save the file before execute the script (command "_CTRL+o_") if you want to apply the configmap automatically after CI enabled.

```
# To finish, apply the "container-azm-ms-agentconfig.yaml" with 'ignore_proxy_settings = "true"" enabled'

# Official Microsoft ConfigMap 
# az aks command invoke  --resource-group $rg_name --name $aks_name --command "kubectl apply -f https://raw.githubusercontent.com/microsoft/Docker-Provider/ci_prod/kubernetes/container-azm-ms-agentconfig.yaml"
#
# Modifed ConfigMap - As an example, enabled "[agent_settings.proxy_config]"
# az aks command invoke  --resource-group $rg_name --name $aks_name --command "kubectl apply -f https://raw.githubusercontent.com/braieralves/AKS-Cluster-Monitoring-environment/refs/heads/main/modified_container-azm-ms-agentconfig.yaml
```
 


