#!/usr/bin/pwsh
param(
  [string]$vcenter, # 1er argumento
  [string]$username, # 2do argumento
  [string]$password, # 3er argumento
  [string]$template # 4to argumento
)
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP:$false | Out-Null
Connect-VIServer -Server $vcenter -Protocol https -User $username -Password $password | Out-Null

# Buscar los templates eligiendo solo aquellos que  coinciden con el patron prefijo ($template),
# ordenarlos de forma descendente y elegir solo el 1ro. Es decir, elegir el template mas reciente de un SO dado
Get-Template | Where-Object { $_.Name -like "${template}*" } | Sort-Object -Descending | Select-Object -First 1 | Select-Object -ExpandProperty Name
