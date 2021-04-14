#!/usr/bin/pwsh
param(
  [string]$vsphere_server,
  [string]$vsphere_user,
  [string]$vsphere_password,
  [string]$vm_datastore,
  [string]$vm_name,
  [string]$nvram_file,
  [string]$folder
)
# Hardcoded settings
$logkeepold = 5
$logrotatesize = 50000000

function PowerOffVM {   
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    # Get the status of the VM
    $status = (Get-VM $vm).PowerState
    if ($status -eq "PoweredOn") {
        Write-Host "VM is powered on. Shutting down gracefully"
        Shutdown-VMGuest -VM $vm -Confirm:$false
        do {
            Write-Host "Waiting for VM to shut down..."
            Start-Sleep -Seconds 1
            # Get the current power status of the vm
            $status = (Get-VM $vm).PowerState
        } until ($status -eq "PoweredOff")
    }
    else {
        Write-Host "VM $vm_name is already offline. Skipping..."
    }
}

function PowerOnVM {   
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    # Get the status of the VM
    $status = (Get-VM $vm).PowerState
    if ($status -ne "PoweredOn") {
	Write-Host "VM is not powered on. Starting it..."
	Start-VM -VM $vm
    }
    else {
	Write-Host "VM is already running. Skipping..."
    }
}

function ConfigSyncTimeWithHost {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    $currentValue = (Get-View $vm).Config.Tools.SyncTimeWithHost
    if (!$currentValue) {
	Write-Host "SyncTimeWithHost is disabled. Enabling it..."
	$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
	$spec.changeVersion = $vm.ExtensionData.Config.ChangeVersion
	$spec.Tools = New-Object VMware.Vim.ToolsConfigInfo
	$spec.Tools.SyncTimeWithHost = $true
	$thisvm = Get-View -Id $vm.Id
	$thisvm.ReconfigVM_Task($spec)
	Write-Host "SyncTimeWithHost was successfully enabled"
    }
    else {
    	Write-Host "SyncTimeWithHost is already enabled. Skipping..."
    }
}

function ConfigToolsUpgradePolicy {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    $currentValue = (Get-View $vm).Config.Tools.ToolsUpgradePolicy
    if ($currentValue -eq "manual") {
	Write-Host "ToolsUpgradePolicy is set to manual. Setting it to UpgradeAtPowerCycle..."
	$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
	$spec.changeVersion = $vm.ExtensionData.Config.ChangeVersion
	$spec.Tools = New-Object VMware.Vim.ToolsConfigInfo
	$spec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
	$thisvm = Get-View -Id $vm.Id
	$thisvm.ReconfigVM_Task($spec)
	Write-Host "ToolsUpgradePolicy was successfully changed to UpgradeAtPowerCycle"
    }
    else {
    	Write-Host "ToolsUpgradePolicy is already set to UpgradeAtPowerCycle. Skipping..."
    }
}

function ConfigLogKeepOld {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    $value = (Get-AdvancedSetting -Entity $vm -Name log.keepOld).Value
    if (!$value -OR $value -ne $logkeepold) {
        Write-Host "log.keepOld is not set to $logkeepold. Setting it to $logkeepold"
        New-AdvancedSetting -Entity $vm -Name log.keepOld -Value $logkeepold -Confirm:$false
    }
    else {
        Write-Host "log.keepOld is already set to $logkeepold. Skipping..."
    }
}

function ConfigLogRotateSize {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    $value = (Get-AdvancedSetting -Entity $vm -Name log.rotateSize).Value
    if (!$value -OR $value -ne $logrotatesize) {
        Write-Host "log.rotateSize is not set to $logrotatesize. Setting it to $logrotatesize..."
        New-AdvancedSetting -Entity $vm -Name log.rotateSize -Value $logrotatesize -Confirm:$false
    }
    else {
        Write-Host "log.rotateSize is already set to $logrotatesize. Skipping..."
    }
}

function RemoveDVDDrive {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    # Get the amount of CD/DVD drives
    $numDrives = (Get-CDDrive -VM $vm | measure).Count
    # If there are more than 2 CD/DVD drives
    if ($numDrives -gt 1) {
        PowerOffVM
        # Get the 2nd CD/DVD drive
        $cd = Get-CDDrive -vm $vm | Where {$_.Name -eq "CD/DVD drive 2"}
        # If 2nd CD/DVD drive exists
        if ($cd) {        
            Write-Host "Removing the 2nd CD/DVD drive..."
            Remove-CDDrive -cd $cd -Confirm:$false
            Write-Host "2nd CD/DVD drive successfully removed. Powering on the VM..."
        }
        else {
            Write-Host "A 2nd CD/DVD drive was not found"
        }
    }
    else {
        Write-Host "VM already has only 1 CD/DVD drive. Skipping..."
    }
}

function ConfigBiosSettings {   
    if ($nvram_file -ne "SKIP") {
        PowerOffVM
        Write-Host "Changing BIOS settings for VM..."
        $dc = (Get-Datacenter -VM $vm).Name
        Copy-DatastoreItem $nvram_file vmstore:\$dc\$vm_datastore\$vm_name\$vm_name.nvram                                                   
        Write-Host "BIOS settings successfully updated"
    }
    else {
        Write-Host "Skipping BIOS setup..."
    }
}

function ConvertToTemplate {
    Write-Host "Convertir $vm_name to template"
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    Set-VM -VM $vm -ToTemplate -Confirm:$false
    $template = Get-Template -Name $vm_name
    Move-Template -Template $template -Destination (Get-Folder -Name $folder)
}
# Connect to vCenter
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false | Out-Null
Connect-VIServer -Server $vsphere_server -Protocol https -User $vsphere_user -Password $vsphere_password | Out-Null

# Customize the VM with recommended settings
ConfigSyncTimeWithHost
ConfigToolsUpgradePolicy
ConfigLogKeepOld
ConfigLogRotateSize
# RemoveDVDDrive
# ConfigBiosSettings
# PowerOffVM
# ConvertToTemplate
