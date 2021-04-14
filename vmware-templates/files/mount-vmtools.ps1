#!/usr/bin/pwsh
param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$vm_datastore,
  [string]$vm_name
)
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false -WebOperationTimeoutSeconds 1200 | Out-Null
Connect-VIServer -Server $vcenter -Protocol https -User $username -Password $password | Out-Null
$vm = Get-VM -Name $vm_name -DataStore $vm_datastore
Mount-Tools -VM $vm
Start-Sleep -s 5
