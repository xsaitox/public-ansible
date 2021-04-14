#!/usr/bin/pwsh 
param( 
  [string]$vcenter, 
  [string]$username, 
  [string]$password 
)
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false | Out-Null 
Connect-VIServer -Server $vcenter -Protocol https -User $username -Password $password | Out-Null
Get-VM | Where-Object {$_.Notes -like "*103107*"} | Select-Object  @{ expression={$_.Name}; label='VM' }, PowerState, @{N="DnsName"; E={$_.ExtensionData.Guest.Hostname}}, @{ expression={$_.NumCpu}; label='CPUs' }, MemoryGB | ConvertTo-Csv | Select-Object -Skip 1