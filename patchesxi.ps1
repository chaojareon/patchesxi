# patchesxi.ps1
# PS script to run on single free esxi host patch update and to reboot
# Info for patching in this manner is at https://esxi-patches.v-front.de/

 param (
    [Parameter(Mandatory=$true)][string]$viserver,
    [Parameter(Mandatory=$true)][string]$profile,
    # depot is typically https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml
    [Parameter(Mandatory=$true)][string]$depot
    $tools-light
 )

Import-Module VMware.PowerCLI
Connect-VIServer -Server $viserver
$esxcli = Get-EsxCli -V2


$patchargs = $esxcli.software.profile.update.createargs()
$patchargs.depot = $depot
$patchargs.profile = $profile
$result = $esxcli.software.profile.update.Invoke($patchargs)
write-output $result
if ($result) {
  $rebootargs = $esxcli.system.shutdown.reboot.CreateArgs()
  $rebootargs.reason = "Patching"
  $result2 = $esxcli.system.shutdown.reboot.Invoke($rebootargs)
  write-output $result2
}
