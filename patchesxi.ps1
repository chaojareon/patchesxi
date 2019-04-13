# patchesxi.ps1
# PS script to run on single free esxi host patch update and to reboot

$viserver = ""
$profiledepot = ""

Import-Module VMware.PowerCLI
Connect-VIServer $viserver
$esxcli = Get-EsxCli -V2
$patchargs = $esxcli.software.vib.install.createargs()
$patchargs.depot = $profiledepot
$esxcli.software.vib.install.Invoke($patchargs)
$rebootargs = $esxcli.system.shutdown.reboot.CreateArgs()
$rebootargs.reason = "Patching"
$esxcli.system.shutdown.reboot.Invoke($rebootargs)
