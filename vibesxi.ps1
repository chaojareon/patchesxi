<#

.SYNOPSIS
This is a powershell script for patching a ESXi host via vib URL.

.DESCRIPTION
The script will install a vib on a single esxi host, given a vib url. Addtionally it will reboot the host if needed.

.EXAMPLE
./vibesxi.ps1 -viserver [ESXi server] -viburl [url to vib]

.NOTES
Tested on Windows 10 PS 5.1, and Powershell Core 6 on Linux. Additionally requires Vmware Powercli, tested on version 11.3.

See VMware Patch Tracker for URLS: https://esxi-patches.v-front.de/

.LINK
Repo: https://github.com/chaojareon/patchesxi
Issues: https://github.com/chaojareon/patchesxi/issues

#>

param (
  [Parameter(Mandatory=$true)][string]$viserver,
  [string]$viburl
)

Connect-VIServer -Server $viserver
$esxcli = Get-EsxCli -V2
$vibargs = $esxcli.software.vib.install.createargs()
$vibargs.viburl = $viburl
$vibargs.force = $true
$vibargs.maintenancemode = $true
$result1 = $esxcli.software.vib.install.Invoke($vibargs)
write-output $result1.message
if ($result1.rebootrequired) {
  $rebootargs = $esxcli.system.shutdown.reboot.CreateArgs()
  $rebootargs.reason = "VIB installed"
  $result2 = $esxcli.system.shutdown.reboot.Invoke($rebootargs)
  write-output $result2
}
