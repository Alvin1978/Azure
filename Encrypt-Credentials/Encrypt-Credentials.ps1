<#
Encrypting Credentials for PowerShell Scripting
https://social.technet.microsoft.com/wiki/contents/articles/4546.working-with-passwords-secure-strings-and-credentials-in-windows-powershell.aspx
#>

Get-ExecutionPolicy
# Unrestricted

# Clear Variables
$SecureStringPW = $null
$UserName = $null
$Credentials = $null
$FolderPath = $null
$FileName = $null
$TenantId = $null
$Environment = $null

# Import Variables
## Oyvind._Admin Azure
. "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind.Admin.ps1"
Get-Content "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind.Admin.ps1"

. "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind_P.ps1"

## Øyvind_Pettersen Azure
. "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind_P.ps1"
Get-Content "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind_P.ps1"

## Kontali
. "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/Kontali/VariablesKontali.ps1"
Get-Content "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/Kontali/VariablesKontali.ps1"

#####################

#Prompter for password, store in secure string variable.
$SecureStringPW = read-host -Prompt 'Enter Your P@sSwOrd' -assecurestring

# Store Username and password in $Credentials variable
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName, $SecureStringPW

#####################

# Connect to Azure
Connect-AzAccount -Tenant $TenantId -Credential $Credentials

Disconnect-AzAccount

#####################

## Export
# Encrypt SecureString and saving to file.
$SecureStringAsPlainText = $SecureStringPW | ConvertFrom-SecureString
$SecureStringAsPlainText | Set-Content $FolderPath+$FileName

## Import
# Import Encrypted string from file, convert to SecureString.
$SecureStringAsPlainText = Get-Content $FolderPath+$FileName
$SecureStringPW = $SecureStringAsPlainText  | ConvertTo-SecureString

# Convert SecureString to PSCredential, store Username and password in $Credentials variable
$Credentials = New-Object System.Management.Automation.PSCredential `
     -ArgumentList $UserName, $SecureStringPW

# Extract password from PSCredentials to ClearText.
$Credentials.GetNetworkCredential().Password



# TODO
# Legg til i Azure Key Vault.