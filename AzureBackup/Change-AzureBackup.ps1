<#
Selective disk backup and restore for Azure virtual machines
https://learn.microsoft.com/en-us/azure/backup/selective-disk-backup-restore#modify-protection-for-already-backed-up-vms-with-powershell
#>



# Azure CLI
## Ensure you're using Az CLI version 2.0.80 or higher. You can get the CLI version with this command:
az --version

## Sign in to the subscription ID, where the Recovery Services vault and the VM exist:
az account set -s {subscriptionID}



# Azure Powershell
## https://learn.microsoft.com/en-us/azure/backup/selective-disk-backup-restore#using-powershell

## Ensure you're using Azure PowerShell version 3.7.0 or higher.
$PSVersionTable

# Backup

## Enable backup with PowerShell
$disks = ("0","1")
$targetVault = Get-AzRecoveryServicesVault -ResourceGroupName "rg-p-recovery_vaults" -Name "rsv-p-servers"
Set-AzRecoveryServicesVaultContext -Vault $targetVault
Get-AzRecoveryServicesBackupProtectionPolicy
$pol = Get-AzRecoveryServicesBackupProtectionPolicy -Name "P-Servers"

Enable-AzRecoveryServicesBackupProtection -Policy $pol -Name "V2VM" -ResourceGroupName "RGName1"  -InclusionDisksList $disks -VaultId $targetVault.ID

Enable-AzRecoveryServicesBackupProtection -Policy $pol -Name "V2VM" -ResourceGroupName "RGName1"  -ExclusionDisksList $disks -VaultId $targetVault.ID

## Backup only OS disk during configure backup with PowerShell
Enable-AzRecoveryServicesBackupProtection -Policy $pol -Name "V2VM" -ResourceGroupName "RGName1"  -ExcludeAllDataDisks -VaultId $targetVault.ID

## Get backup item object to be passed in modify protection with PowerShell
$item= Get-AzRecoveryServicesBackupItem -BackupManagementType "AzureVM" -WorkloadType "AzureVM" -VaultId $targetVault.ID -FriendlyName "V2VM"
### You need to pass the above obtained $item object to the –Item parameter in the following cmdlets.


## Modify protection for already backed up VMs with PowerShell
### Include Disks
Enable-AzRecoveryServicesBackupProtection -Item $item -InclusionDisksList[Strings] -VaultId $targetVault.ID
### Exclude Disks
Enable-AzRecoveryServicesBackupProtection -Item $item -ExclusionDisksList[Strings] -VaultId $targetVault.ID

## Backup only OS disk during modify protection with PowerShell
Enable-AzRecoveryServicesBackupProtection -Item $item  -ExcludeAllDataDisks -VaultId $targetVault.ID

## Reset disk exclusion setting with PowerShell
Enable-AzRecoveryServicesBackupProtection -Item $item -ResetExclusionSettings -VaultId $targetVault.ID


# Restore

## Restore selective disks with PowerShell
$startDate = (Get-Date).AddDays(-7)
$endDate = Get-Date
$rp = Get-AzRecoveryServicesBackupRecoveryPoint -Item $item -StartDate $startdate.ToUniversalTime() -EndDate $enddate.ToUniversalTime() -VaultId $targetVault.ID
Restore-AzRecoveryServicesBackupItem -RecoveryPoint $rp[0] -StorageAccountName "DestAccount" -StorageAccountResourceGroupName "DestRG" -TargetResourceGroupName "DestRGforManagedDisks" -VaultId $targetVault.ID -RestoreDiskList [$disks]

## Restore only OS disk with PowerShell
Restore-AzRecoveryServicesBackupItem -RecoveryPoint $rp[0] -StorageAccountName "DestAccount" -StorageAccountResourceGroupName "DestRG" -TargetResourceGroupName "DestRGforManagedDisks" -VaultId $targetVault.ID -RestoreOnlyOSDisk