<#
https://learn.microsoft.com/nb-no/training/modules/automate-azure-tasks-with-powershell/5-create-resource-interactively?pivots=macos

Getting information for a VM
You can list the VMs in your subscription using the Get-AzVM -Status command. 
This command also supports entering a specific VM by including the -Name property. Here, we will assign it to a PowerShell variable:
#>
# PowerShell

$vm = Get-AzVM  -Name MyVM -ResourceGroupName ExerciseResources
#The interesting thing is that now your VM is an object with which you can interact. For example, you can make changes to that object, then push changes back to Azure by using the Update-AzVM command:

# PowerShell

$ResourceGroupName = "ExerciseResources"
$vm = Get-AzVM  -Name MyVM -ResourceGroupName $ResourceGroupName
$vm.HardwareProfile.vmSize = "Standard_DS3_v2"

Update-AzVM -ResourceGroupName $ResourceGroupName  -VM $vm

PowerShell

Kopier
   New-AzVm
       -ResourceGroupName <resource group name>
       -Name <machine name>
       -Credential <credentials object>
       -Location <location>
       -Image <image name>
You can supply these parameters directly to the cmdlet as shown above. Alternatively, you can use other cmdlets to configure the virtual machine, such as Set-AzVMOperatingSystem, Set-AzVMSourceImage, Add-AzVMNetworkInterface, and Set-AzVMOSDisk.

Here is an example that strings the Get-Credential cmdlet together with the -Credential parameter:

PowerShell

Kopier
New-AzVM -Name MyVm -ResourceGroupName ExerciseResources -Credential (Get-Credential) ...
The AzVM suffix is specific to VM-based commands in PowerShell.