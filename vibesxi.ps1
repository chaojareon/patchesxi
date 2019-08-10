# vibesxi.ps1
# PS script to run on single esxi host specified viburl and to reboot

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
