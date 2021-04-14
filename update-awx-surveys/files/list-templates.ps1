#!/usr/bin/pwsh
param(
  [string]$vcenter,
  [string]$username,
  [string]$password
)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false | Out-Null
Connect-VIServer -Server $vcenter -Protocol https -User $username -Password $password | Out-Null
Get-Template | Where-Object { $_.Name -like "img_*" } | Select-Object -ExpandProperty Name | ForEach-Object { $_.Split('_')[1] } | Sort-Object | Get-Unique
