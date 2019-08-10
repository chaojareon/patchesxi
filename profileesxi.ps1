<#

.SYNOPSIS
This is a powershell script for patching a ESXi host via profile and depot URL.

.DESCRIPTION
The script will install a series of patches on a single esxi host, given a profile and a depot url. Addtionally it will reboot the host if needed.

.EXAMPLE
./profileesxi.ps1 -viserver [ESXi server] -profile [profile name] -depot [url to depot]

.NOTES
Tested on Windows 10 PS 5.1, and Powershell Core 6 on Linux. Additionally requires Vmware Powercli, tested on version 11.3.

See VMware Patch Tracker for URLS: https://esxi-patches.v-front.de/

.LINK
Repo: https://github.com/chaojareon/patchesxi
Issues: https://github.com/chaojareon/patchesxi/issues

#>
param (
  [Parameter(Mandatory=$true)][string]$viserver,
  [Parameter(Mandatory=$true)][string]$profile,
  [Parameter(Mandatory=$true)][string]$depot
)

Connect-VIServer -Server $viserver
$esxcli = Get-EsxCli -V2
$patchargs = $esxcli.software.profile.update.createargs()
$patchargs.depot = $depot
$patchargs.profile = $profile
$patchargs.force = $true
$result1 = $esxcli.software.profile.update.Invoke($patchargs)
write-output $result1.message
if ($result1.rebootrequired) {
  $rebootargs = $esxcli.system.shutdown.reboot.CreateArgs()
  $rebootargs.reason = "Patching"
  $result2 = $esxcli.system.shutdown.reboot.Invoke($rebootargs)
  write-output $result2.message
}
