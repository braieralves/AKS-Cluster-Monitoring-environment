#!/bin/bash
########################################################################################################
#  Script created by Braier Alexandre.
#  The purpose of this script is to automate a complete environment for Container Insights and Managed Prometheus testing.
#  Resources created by this script: - Resource Group in "East US 2" region - Log Analytics Workspace 
#  - Azure Monitor Workspace (Managed Prometheus) 
#   - Managed Grafana 
#   - AKS cluster enabled Container Insights, managed Prometheus and Managed Grafana 
#   - DCRs for Container Insights and Managed Prometheus
########################################################################################################
#
# ATTENTION! You don't need change anything in this script. Just run it :)
#
########################################################################################################
# Script execution start!!!!
#
# Choose resources names
#
echo "Choose a name for your Resource Group:"
read rg_name
#
echo "Choose a name for your AKS cluster:"
read aks_name
#
echo "Choose a name for your Log Analytics Workspace:"
read law_name
#
echo "Choose a name for your Managed Prometheus:"
read amw_name
#
echo "Choose a name for your Managed Grafana:"
read amg_name
#
# Create a New Resource Group in East US 2
az group create --name $rg_name --location eastus2
#
# Create a Log Analytics Workspace in the New Resource Group
az monitor log-analytics workspace create --resource-group $rg_name --workspace-name $law_name --location eastus2
#
# Create a Managed Prometheus (Azure monitor Workspace) in the New Resource Group
az monitor account create --resource-group $rg_name --name $amw_name --location eastus2
#
# Create a Managed Grafana in the New Resource Group
az grafana create --resource-group $rg_name --workspace-name $amg_name --sku-tier Standard --public-network-access Enabled --location eastus2
#
# Create an AKS Cluster in the New Resource Group with Monitoring addon Enabled
#
# The first command retrieves the ID of a specified Log Analytics workspace and stores it in the workspaceId variable.
workspaceId=$(az monitor log-analytics workspace show --resource-group $rg_name --workspace-name $law_name --query id -o tsv)
#
# The second command creates an AKS cluster with monitoring enabled, linking it to the Log Analytics workspace using the retrieved ID. This setup integrates Azure Monitor for containers with the AKS cluster.
az aks create --resource-group $rg_name --name $aks_name --node-count 2 --enable-addons monitoring --generate-ssh-keys --workspace-resource-id $workspaceId
#
# The third command retrieves the ID of a specified Managed Prometheus and stores it in the workspaceId variable.
prometheusId=$(az monitor account show --resource-group $rg_name -n $amw_name --query id -o tsv)
#
# The fourth command retrieves the ID of a specified Managed Grafana and stores it in the workspaceId variable.
grafanaId=$(az grafana show --resource-group $rg_name -n $amg_name --query id -o tsv)
#
# The fifth update the AKS cluster to be monitored by Managed Prometheus and Managed Grafana
az aks update --enable-azure-monitor-metrics --name $aks_name --resource-group $rg_name --azure-monitor-workspace-resource-id $prometheusId --grafana-resource-id $grafanaId
#
# To finish, apply the "container-azm-ms-agentconfig.yaml". Uncomment the next line if you want apply the ama-logs configmap.
#
# Official Microsoft ConfigMap 
az aks command invoke  --resource-group $rg_name --name $aks_name --command "kubectl apply -f https://raw.githubusercontent.com/microsoft/Docker-Provider/ci_prod/kubernetes/container-azm-ms-agentconfig.yaml"
#
