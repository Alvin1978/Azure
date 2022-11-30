<#
https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-powershell

#>
#Import Variables
Get-Content "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind.Admin.ps1"
. "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/VariablesOyvind.Admin.ps1"

# Connect Azure
& "/Users/oyvindpettersen/Jottacloud/Coding/Github repositories/Azure/Aztek Customers/Kontali/Azure-ConnectAzure.ps1"

# Disconnect Azure 
Disconnect-AzAccount

# Create a resource group
$VaultRG = "rg-myResources"
New-AzResourceGroup -Name $VaultRG -Location $location

# Create a key vault
$VaultName = "kv-myKeyVault"
$NewVault = New-AzKeyVault -Name $VaultName -ResourceGroupName $VaultRG -Location $location
$NewVault = Get-AzKeyVault -VaultName kv-myKeyVault -ResourceGroupName rg-myResources
$NewVault.VaultName
$NewVault.VaultUri
Get-AzKeyVault -VaultName kv-myKeyVault -ResourceGroupName rg-myResources
<#
The output of this cmdlet shows properties of the newly created key vault. Take note of the two properties listed below:

    Vault Name: The name you provided to the -Name parameter above.
    Vault URI: In the example, this is https://<your-unique-keyvault-name>.vault.azure.net/. Applications that use your vault through its REST API must use this URI.

At this point, your Azure account is the only one authorized to perform any operations on this new vault.
#>


# Add a key to Key Vault
## To add a key to the vault, you just need to take a couple of additional steps. This key could be used by an application.
Add-AzKeyVaultKey -VaultName $NewVault.VaultName -Name "ExampleKey" -Destination "Software"


# To view previously stored key:
Get-AzKeyVaultKey -VaultName $NewVault.VaultName -KeyName "ExampleKey"

# Now, you have created a Key Vault, stored a key, and retrieved it.


Get-Help Add-AzKeyVaultKey -Examples


<#

Secrets
https://learn.microsoft.com/en-us/azure/key-vault/secrets/

#>

# Adding a secret to Key Vault
##To add a secret to the vault, you just need to take a couple of steps. In this case, you add a password that could be used by an application. The password is called ExamplePassword and stores the value of hVFkk965BuUv in it.

##First convert the value of hVFkk965BuUv to a secure string by typing:

$secretvalue = ConvertTo-SecureString "hVFkk965BuUv" -AsPlainText -Force

#Then, use the Azure PowerShell Set-AzKeyVaultSecret cmdlet to create a secret in Key Vault called ExamplePassword with the value hVFkk965BuUv :

$secret = Set-AzKeyVaultSecret -VaultName $NewVault.VaultName -Name "ExamplePassword" -SecretValue $secretvalue


# Retrieve a secret from Key Vault

$secret = Get-AzKeyVaultSecret -VaultName $NewVault.VaultName -Name "ExamplePassword" -AsPlainText

Now, you have created a Key Vault, stored a secret, and retrieved it.
