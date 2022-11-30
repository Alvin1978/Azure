# Clear Variables
$SecureStringPW = $null
$Credentials = $null
$FolderPath = $null
$FileName = $null
$Environment = $null


# Import Variables

## Oyvind.Admin
. "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind.Admin.ps1"
#Get-Content "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind.Admin.ps1"
## Øyvind_P Azure
# . "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind_P.ps1"
# Get-Content "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind_P.ps1"

## Kontali
# . "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/Kontali/VariablesKontali.ps1"
# Get-Content "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/Kontali/VariablesKontali.ps1"

# Import Credentials
# Import Encrypted string from file, convert to SecureString.
$SecureStringAsPlainText = Get-Content $FolderPath+$FileName
$SecureStringPW = $SecureStringAsPlainText  | ConvertTo-SecureString

# Convert SecureString to PSCredential, store Username and password in $Credentials variable
$Credentials = New-Object System.Management.Automation.PSCredential `
     -ArgumentList $UserName, $SecureStringPW



#Connect to Azure.
Connect-AzAccount -Tenant $TenantId -Environment $Environment -Subscription $SubscriptionId -Credential $Credentials

<#
#Check Azure connection
Function AZConnectCheck{
Get-AzContext
Get-AzSubscription #List Azure Subscriptions
Get-AzStorageUsage -location $location
Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -like "*avd*"}
Get-AzVM
}




# Disconnect Azure 
# https://docs.microsoft.com/en-us/powershell/module/az.accounts/Disconnect-AzAccount?view=azps-1.4.0
Disconnect-AzAccount





## Azure Subscriptions
# List Azure Subscriptions
Get-AzSubscription
# Set subscription by Id
Set-AzContext -SubscriptionId "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"

# Set subscription by Name
Set-AzContext -SubscriptionName "AME-Prod"

#>