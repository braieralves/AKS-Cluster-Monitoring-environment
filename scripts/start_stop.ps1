Import-Module -Name Az
# Set the start and stop times in UTC
$startTime = "08:00:00"
$stopTime = "13:00:00"

# Get the current time in UTC
$currentTime = (Get-Date).AddHours(1)

# Get the AKS cluster object
$aks = Get-AzAks -Name $aks_name -ResourceGroupName $rg_name 
-Credential (Get-AutomationPSCredential -Name "AzureRunAsConnection")

# Check if the AKS cluster is running
if ($aks.State -eq "Running") {
    # Check if the current time is after the stop time
    if ($currentTime.TimeOfDay -gt $stopTime) {
        # Stop the AKS cluster
        Stop-AzAks -Name $aks_name -ResourceGroupName $rg_name  
        -Credential (Get-AutomationPSCredential -Name "AzureRunAsConnection")
    }
} else {
    # Check if the current time is after the start time
    if ($currentTime.TimeOfDay -gt $startTime) {
        # Start the AKS cluster
        Start-AzAks -Name $aks_name -ResourceGroupName $rg_name 
        -Credential (Get-AutomationPSCredential -Name "AzureRunAsConnection")
    }
}
