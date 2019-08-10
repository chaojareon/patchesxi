# eosxi.ps1
# PS script to run on single ESXi host to patch update via profile method and to reboot
# Info for patching in this manner is at https://esxi-patches.v-front.de/

param (
  [Parameter(Mandatory=$true)][string]$viserver,
  [Parameter(Mandatory=$true)][string]$profile,
  # depot is typically https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml
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
