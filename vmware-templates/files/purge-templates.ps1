#!/usr/bin/pwsh
param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$template,
  [string]$maxkeep
)
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false | Out-Null
Connect-VIServer -Server $vcenter -Protocol https -User $username -Password $password | Out-Null
$pattern = 'img_' + $template + '_'
Get-Template -Name $pattern* | Select-Object -ExpandProperty Name | Sort-Object | Select-Object -SkipLast $maxkeep |
foreach {
  Remove-Template -Template $_ -DeletePermanently -Confirm:$false
}
