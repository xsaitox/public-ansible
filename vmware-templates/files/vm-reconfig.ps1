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
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
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
}

function PowerOnVM {   
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
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
}

function ConfigSyncTimeWithHost {
    $vm = Get-VM -DataStore "$vm_datastore" -Name "$vm_name"
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
        Write-Host "ConfigSyncTimeWithHost: VM $vm_name, Datastore $vm_datastore, VM $vm"
        $currentValue = (Get-View $vm).Config.Tools.SyncTimeWithHost
        Write-Host "ConfigSyncTimeWithHost: SyncTimeWithHost current value is $currentValue"
        if (!$currentValue) {
            Write-Host "SyncTimeWithHost is disabled. Enabling it..."
            $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
            $spec.changeVersion = $vm.ExtensionData.Config.ChangeVersion
            $spec.Tools = New-Object VMware.Vim.ToolsConfigInfo
            $spec.Tools.SyncTimeWithHost = $true
            $thisvm = Get-View -Id $vm.Id
            $thisvm.ReconfigVM_Task($spec)
            $newValue = (Get-View $vm).Config.Tools.SyncTimeWithHost
            Write-Host "ConfigSyncTimeWithHost: SyncTimeWithHost new value is $newValue"
            Write-Host "SyncTimeWithHost was successfully enabled"
        }
        else {
            Write-Host "SyncTimeWithHost is already enabled. Skipping..."
        }
    }
}

function ConfigToolsUpgradePolicy {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
        Write-Host "ConfigToolsUpgradePolicy: VM $vm_name"
        $currentValue = (Get-View $vm).Config.Tools.ToolsUpgradePolicy
        Write-Host "ConfigToolsUpgradePolicy: ToolsUpgradePolicy current value is $currentValue"
        if ($currentValue -eq "manual") {
            Write-Host "ToolsUpgradePolicy is set to manual. Setting it to UpgradeAtPowerCycle..."
            $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
            $spec.changeVersion = $vm.ExtensionData.Config.ChangeVersion
            $spec.Tools = New-Object VMware.Vim.ToolsConfigInfo
            $spec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
            $thisvm = Get-View -Id $vm.Id
            $thisvm.ReconfigVM_Task($spec)
            $newValue = (Get-View $vm).Config.Tools.ToolsUpgradePolicy
            Write-Host "ConfigToolsUpgradePolicy: ToolsUpgradePolicy new value is $newValue"
            Write-Host "ToolsUpgradePolicy was successfully changed to UpgradeAtPowerCycle"
        }
        else {
            Write-Host "ToolsUpgradePolicy is already set to UpgradeAtPowerCycle. Skipping..."
        }
    }
}

function ConfigCPUHotAdd {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
        Write-Host "CPUHotAddEnabled: VM $vm_name"
        $currentValue = (Get-View $vm).Config.CPUHotAddEnabled
        if (!$currentValue) {
            Write-Host "CPUHotAddEnabled is disabled. Enabling it..."
            $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
            $spec.CPUHotAddEnabled = $true
            $vm.ExtensionData.ReconfigVM_Task($spec)
            $newValue = (Get-View $vm).Config.CPUHotAddEnabled
            Write-Host "ConfigCPUHotAdd: CPUHotAddEnabled new value is $newValue"
            Write-Host "CPUHotAddEnabled was successfully enabled"
        }
        else {
            Write-Host "CPUHotAddEnabled is already enabled. Skipping..."
        }
    }
}

function ConfigMemoryHotAdd {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
        Write-Host "MemoryHotAddEnabled: VM $vm_name"
        $currentValue = (Get-View $vm).Config.MemoryHotAddEnabled
        if (!$currentValue) {
            Write-Host "MemoryHotAddEnabled is disabled. Enabling it..."
            $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
            $spec.MemoryHotAddEnabled = $true
            $vm.ExtensionData.ReconfigVM_Task($spec)
            $newValue = (Get-View $vm).Config.MemoryHotAddEnabled
            Write-Host "ConfigMemoryHotAdd: MemoryHotAddEnabled new value is $newValue"
            Write-Host "MemoryHotAddEnabled was successfully enabled"
        }
        else {
            Write-Host "MemoryHotAddEnabled is already enabled. Skipping..."
        }
    }
}

function ConfigLogKeepOld {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
        Write-Host "ConfigLogKeepOld: VM $vm_name"
        $currentValue = (Get-AdvancedSetting -Entity $vm -Name log.keepOld).Value
        Write-Host "ConfigLogKeepOld: log.keepOld current value is $currentValue"
        if (!$currentValue -OR $currentValue -ne $logkeepold) {
            Write-Host "log.keepOld is not set to $logkeepold. Setting it to $logkeepold"
            New-AdvancedSetting -Entity $vm -Name log.keepOld -Value $logkeepold -Confirm:$false
            $newValue = (Get-AdvancedSetting -Entity $vm -Name log.keepOld).Value
            Write-Host "ConfigLogKeepOld: log.keepOld new value is $newValue"
        }
        else {
            Write-Host "log.keepOld is already set to $logkeepold"
        }
    }
}

function ConfigLogRotateSize {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
        Write-Host "ConfigLogRotateSize: VM $vm_name"
        $currentValue = (Get-AdvancedSetting -Entity $vm -Name log.rotateSize).Value
        Write-Host "ConfigLogRotateSize: log.rotateSize current value is $currentValue"
        if (!$currentValue -OR $currentValue -ne $logrotatesize) {
            Write-Host "log.rotateSize is not set to $logrotatesize. Setting it to $logrotatesize..."
            New-AdvancedSetting -Entity $vm -Name log.rotateSize -Value $logrotatesize -Confirm:$false
            $newValue = (Get-AdvancedSetting -Entity $vm -Name log.rotateSize).Value
            Write-Host "ConfigLogRotateSize: log.rotateSize new value is $newValue"
        }
        else {
            Write-Host "log.rotateSize is already set to $logrotatesize"
        }
    }
}

function RemoveDVDDrive {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
        # Get the amount of CD/DVD drives
        $numDrives = (Get-CDDrive -VM $vm | Measure-Object).Count
        # If there are more than 2 CD/DVD drives
        if ($numDrives -gt 1) {
            PowerOffVM
            # Get the 2nd CD/DVD drive
            $cd = Get-CDDrive -vm $vm | Where-Object {$_.Name -eq "CD/DVD drive 2"}
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
}

function ConfigBiosSettings {   
    if ($nvram_file -ne "SKIP") {
        $vm = Get-VM -DataStore $vm_datastore -Name $vm_name
        if (!$vm) {
            Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
        }
        else {    
            PowerOffVM
            Write-Host "Changing BIOS settings for VM..."
            $dc = (Get-Datacenter -VM $vm).Name
            Copy-DatastoreItem $nvram_file vmstore:\$dc\$vm_datastore\$vm_name\$vm_name.nvram                                                   
            Write-Host "BIOS settings successfully updated"
        }
    }
    else {
        Write-Host "Skipping BIOS setup..."
    }
}

function ConvertToTemplate {
    $vm = Get-VM -DataStore $vm_datastore -Name $vm_name

    if (!$vm) {
        Write-Host "No fue posible encontrar la VM $vm_name y Datastore $vm_datastore en $vsphere_server"
    }
    else {
        $suffix = Get-Date -Format "yyyy-MM-dd_HH-mm"
        Write-Host "Definir formato de fecha a $suffix"

        Write-Host "Convertir VM $vm_name a plantilla"
        Set-VM -VM $vm -ToTemplate -Confirm:$false

        $newvm_name = 'img_' + $vm_name + '_' + $suffix
        Write-Host "Definir nuevo nombre de plantilla a $newvm_name"

        Write-Host "Renombrar plantilla $vm_name to $newvm_name"
        Set-VM -VM $vm -Name $newvm_name -Confirm:$false

        $template = Get-Template -Name $newvm_name
        Write-Host "Buscar template de nombre $newvm_name"

        Move-Template -Template $template -Destination (Get-Folder -Name $folder)
        Write-Host "Mover template $newvm_name a carpeta $folder"
    }
}

# Connect to vCenter
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false | Out-Null
Write-Host "Logging into $vsphere_server..."
Connect-VIServer -Server $vsphere_server -Protocol https -User $vsphere_user -Password $vsphere_password | Out-Null

if (!$?) {
    Write-Host "No se pudo autenticar a $vsphere_server con la clave de $vsphere_user"
}
else {
    # Customize the VM with recommended settings
    Write-Host "Configurando sincronizacion de hora con host: ConfigSyncTimeWithHost"
    ConfigSyncTimeWithHost
    Write-Host "Configurando politica de upgrade de VMware Tools: ConfigToolsUpgradePolicy"
    ConfigToolsUpgradePolicy
    Write-Host "Configurando CPU Hot Add"
    ConfigCPUHotAdd
    Write-Host "Configurando Memory Hot Add"
    ConfigMemoryHotAdd
    Write-Host "Configurando almacenamiento de logs de VM: ConfigLogKeepOld"
    ConfigLogKeepOld
    Write-Host "Configurando rotacion de logs de VM: ConfigLogRotateSize"
    ConfigLogRotateSize
    Write-Host "Eliminando unidad DVD excedente: RemoveDVDDrive"
    RemoveDVDDrive
    Write-Host "Configurando parametros de BIOS de la VM: ConfigBiosSettings"
    ConfigBiosSettings
    Write-Host "Apagando la VM: PowerOffVM"
    PowerOffVM
    Write-Host "Convirtiendo la VM a template: ConvertToTemplate"
    ConvertToTemplate
}
