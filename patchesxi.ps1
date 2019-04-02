# patchesxi.ps1
# PS script to run on single free esxi host patch update and to reboot

$viserver = "[host name or IP]"
$profiledepot = "[url to depot]"
$profile = "[profile name]"

Import-Module VMware.PowerCLI
Connect-VIServer $viserver
$esxcli = Get-EsxCli -V2
$patchargs = $esxcli.software.profile.update.createargs()
$patchargs.depot = $profiledepot
$patchargs.profile = $profiledepot
$esxcli.software.profile.update.Invoke($patchargs)
$rebootargs = $esxcli.system.shutdown.reboot.CreateArgs()
$esxcli.system.shutdown.reboot.Invoke($rebootargs)
