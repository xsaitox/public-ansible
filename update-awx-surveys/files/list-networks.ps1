#!/usr/bin/pwsh
param(
  [Parameter(Mandatory=$true)] [string]$vcenter,
  [Parameter(Mandatory=$true)] [string]$username,
  [Parameter(Mandatory=$true)] [string]$password,
  [Parameter(Mandatory=$true)] [string]$type,
  [Parameter(Mandatory=$false)] [string]$pattern = "^V_"
)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false | Out-Null
Connect-VIServer -Server $vcenter -Protocol https -User $username -Password $password | Out-Null

if ($type -eq "BKP") {
  Get-VDPortgroup | Select-Object -ExpandProperty Name | Sort-Object | Select-String -Pattern "$pattern" | Select-String -Pattern "BKP" | %{ $_.Line }
}
else {
  Get-VDPortgroup | Select-Object -ExpandProperty Name | Sort-Object |Select-String -Pattern "$pattern" | Select-String -Pattern "BKP" -NotMatch | %{ $_.Line }
}
