#!/usr/bin/pwsh
param(
  [string]$vcenter, # 1er argumento
  [string]$username, # 2do argumento
  [string]$password, # 3er argumento
  [string]$vmName, # 4to argumento
  [string]$newSize # 5to argumento
)
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false | Out-Null
Connect-VIServer -Server $vcenter -Protocol https -User $username -Password $password | Out-Null

Get-HardDisk -VM $(Get-VM -Name $vmName) | Where-Object { $_.Name -eq "Hard Disk 1" } | Set-HardDisk -Confirm:$false  -CapacityGB $newSize
