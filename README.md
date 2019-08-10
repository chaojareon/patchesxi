# patchesxi
Powershell/Powercli scripts to update ESXi from the cli without having to enable ssh on ESXi.

## Usage

There are two scripts to chose from `vibesxi.ps1` and `profileesxi.ps1`.

You will likely need to use the info off VMware ESXi Patch Tracker: https://esxi-patches.v-front.de/

`vibesxi` uses the vib install method. You can either just run:

```> vibesxi.ps1```
 
And enter the arguments interactively.

Alternatively you can use:

```> vibesxi.ps1 -viserver [esxi server] -viburl [url to the vib]```

Note there are typically multiple vibs per update, you would need to run this for each vib. It should only reboot if it needs a reboot.

If you use the profile method you should only have to run this single command to roll in all the vibs:

```> profileesxi.ps1```

And enter the arguments interactively. Alternatively you can use:

```> profileesxi.ps1 -viserver [esxi server] -profile [profile name] -depot [url to depot]```

## Note

* This was tested in Windows 10 and Powershell Core 6 on Linux.
* Have been using mostly vib install instead of profile as the profile method runs into errors in my tiny lab.

